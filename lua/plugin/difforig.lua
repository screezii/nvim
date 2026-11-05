-- GitHub-style unified diff of the current buffer against the file on disk.
--   :DiffOrig        open the diff view
--   q / <Esc>        close the view
--   <CR>             jump to the line in the source buffer
--   ]c / [c          next / previous hunk

local ns = vim.api.nvim_create_namespace("difforig")
local CONTEXT = 3
local PREFIX_LEN = 2 -- "+ ", "- ", "  "

---------------------------------------------------------------------------
-- Highlights (default=true so a colorscheme can override them)
---------------------------------------------------------------------------
local function set_highlights()
	local dark = vim.o.background == "dark"
	local c = dark
			and {
				add = "#14261c",
				add_text = "#1f5730",
				add_fg = "#3fb950",
				del = "#2d161a",
				del_text = "#6e2229",
				del_fg = "#f85149",
				hunk = "#121d2f",
				hunk_fg = "#8b949e",
				nr = "#6e7681",
			}
		or {
			add = "#e6ffec",
			add_text = "#abf2bc",
			add_fg = "#1a7f37",
			del = "#ffebe9",
			del_text = "#ffc0c0",
			del_fg = "#cf222e",
			hunk = "#ddf4ff",
			hunk_fg = "#57606a",
			nr = "#8c959f",
		}
	local hl = function(name, opts)
		opts.default = true
		vim.api.nvim_set_hl(0, name, opts)
	end
	hl("DiffOrigAdd", { bg = c.add })
	hl("DiffOrigAddText", { bg = c.add_text })
	hl("DiffOrigAddSign", { fg = c.add_fg, bg = c.add, bold = true })
	hl("DiffOrigAddNr", { fg = c.nr, bg = c.add })
	hl("DiffOrigDelete", { bg = c.del })
	hl("DiffOrigDeleteText", { bg = c.del_text })
	hl("DiffOrigDeleteSign", { fg = c.del_fg, bg = c.del, bold = true })
	hl("DiffOrigDeleteNr", { fg = c.nr, bg = c.del })
	hl("DiffOrigHunk", { fg = c.hunk_fg, bg = c.hunk, italic = true })
	hl("DiffOrigNr", { fg = c.nr })
	hl("DiffOrigStatAdd", { fg = c.add_fg, bold = true })
	hl("DiffOrigStatDel", { fg = c.del_fg, bold = true })
end

set_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("DiffOrigHighlights", { clear = true }),
	callback = set_highlights,
})

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------
local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "DiffOrig" })
end

--- Split a line into word / whitespace / single-char tokens (UTF-8 aware).
local function tokenize(s)
	local tokens, pos = {}, 1
	while pos <= #s do
		local _, e = s:find("^[%w_]+", pos)
		if not e then
			_, e = s:find("^%s+", pos)
		end
		if not e then
			_, e = s:find("^[%z\1-\127\194-\244][\128-\191]*", pos)
		end
		e = e or pos
		tokens[#tokens + 1] = s:sub(pos, e)
		pos = e + 1
	end
	return tokens
end

--- Byte ranges ({start_col, end_col}, 0-based, end-exclusive) of the tokens
--- that differ between a and b.
local function word_diff(a, b)
	local ta, tb = tokenize(a), tokenize(b)
	if #ta == 0 or #tb == 0 then
		return {}, {}
	end
	local hunks = vim.text.diff(table.concat(ta, "\n") .. "\n", table.concat(tb, "\n") .. "\n", {
		result_type = "indices",
		algorithm = "histogram",
	}) --[[@as integer[][] ]]

	local function offsets(tokens)
		local off, acc = {}, 0
		for i, t in ipairs(tokens) do
			off[i] = acc
			acc = acc + #t
		end
		off[#tokens + 1] = acc
		return off
	end
	local oa, ob = offsets(ta), offsets(tb)

	local ra, rb = {}, {}
	for _, h in ipairs(hunks) do
		local sa, ca, sb, cb = h[1], h[2], h[3], h[4]
		if ca > 0 then
			ra[#ra + 1] = { oa[sa], oa[sa + ca] }
		end
		if cb > 0 then
			rb[#rb + 1] = { ob[sb], ob[sb + cb] }
		end
	end
	return ra, rb
end

--- Validate the buffer and return its path on disk, or nil + error message.
local function resolve_file(buf)
	local bo = vim.bo[buf]
	local name = vim.api.nvim_buf_get_name(buf)

	if bo.buftype ~= "" then
		return nil, ("Not a file buffer (buftype=%s, filetype=%s)"):format(bo.buftype, bo.filetype)
	end
	if name == "" then
		return nil, "Buffer has no name; save it to a file first"
	end
	if name:match("^%a[%w+.-]*://") then
		return nil, "Not a local file: " .. name
	end

	local path = vim.fn.fnamemodify(name, ":p")
	if vim.fn.isdirectory(path) == 1 then
		return nil, "Cannot diff a directory: " .. vim.fn.fnamemodify(path, ":~")
	end
	if vim.fn.filereadable(path) == 0 then
		return nil, "File does not exist on disk yet: " .. vim.fn.fnamemodify(path, ":~:.")
	end
	if bo.binary then
		return nil, "Cannot diff a binary buffer"
	end
	return path
end

local function read_disk(path, buf)
	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok then
		return nil, "Failed to read file: " .. tostring(lines)
	end
	if vim.bo[buf].fileformat == "dos" then
		for i, l in ipairs(lines) do
			lines[i] = l:gsub("\r$", "")
		end
	end
	return lines
end

---------------------------------------------------------------------------
-- Rendering
---------------------------------------------------------------------------

--- Build display rows from a unified diff.
--- Each row: { kind = "hunk"|"add"|"del"|"ctx", text, old, new }
local function build_rows(old_lines, new_lines)
	local diff = vim.text.diff(
		table.concat(old_lines, "\n") .. "\n",
		table.concat(new_lines, "\n") .. "\n",
		{ ctxlen = CONTEXT, algorithm = "histogram", indent_heuristic = true }
	) --[[@as string]]

	local rows, adds, dels = {}, 0, 0
	local o, n = 0, 0
	for line in vim.gsplit(diff, "\n", { plain = true }) do
		local os_, ns_ = line:match("^@@ %-(%d+),?%d* %+(%d+),?%d* @@")
		if os_ then
			o, n = tonumber(os_), tonumber(ns_)
			-- for zero-length ranges the start is the line *before*
			if line:match("^@@ %-%d+,0 ") then
				o = o + 1
			end
			if line:match("%+%d+,0 @@") then
				n = n + 1
			end
			rows[#rows + 1] = { kind = "hunk", text = line }
		else
			local sign, text = line:sub(1, 1), line:sub(2)
			if sign == "+" then
				rows[#rows + 1] = { kind = "add", text = text, new = n }
				n, adds = n + 1, adds + 1
			elseif sign == "-" then
				rows[#rows + 1] = { kind = "del", text = text, old = o }
				o, dels = o + 1, dels + 1
			elseif sign == " " then
				rows[#rows + 1] = { kind = "ctx", text = text, old = o, new = n }
				o, n = o + 1, n + 1
			end
		end
	end
	return rows, adds, dels
end

local KIND_HL = {
	add = { line = "DiffOrigAdd", sign = "DiffOrigAddSign", nr = "DiffOrigAddNr", prefix = "+ " },
	del = { line = "DiffOrigDelete", sign = "DiffOrigDeleteSign", nr = "DiffOrigDeleteNr", prefix = "- " },
	ctx = { nr = "DiffOrigNr", prefix = "  " },
}

local function render(buf, rows)
	local width = 1
	for _, r in ipairs(rows) do
		width = math.max(width, #tostring(r.old or 0), #tostring(r.new or 0))
	end

	local lines = {}
	for i, r in ipairs(rows) do
		lines[i] = r.kind == "hunk" and r.text or (KIND_HL[r.kind].prefix .. r.text)
	end
	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

	local blank = (" "):rep(width)
	for i, r in ipairs(rows) do
		local lnum = i - 1
		if r.kind == "hunk" then
			vim.api.nvim_buf_set_extmark(buf, ns, lnum, 0, {
				line_hl_group = "DiffOrigHunk",
				virt_text = { { blank .. " " .. blank .. "   ", "DiffOrigHunk" } },
				virt_text_pos = "inline",
			})
		else
			local k = KIND_HL[r.kind]
			local gutter = ("%" .. width .. "s %" .. width .. "s │ "):format(r.old or "", r.new or "")
			vim.api.nvim_buf_set_extmark(buf, ns, lnum, 0, {
				line_hl_group = k.line,
				virt_text = { { gutter, k.nr } },
				virt_text_pos = "inline",
			})
			if k.sign then
				vim.api.nvim_buf_set_extmark(buf, ns, lnum, 0, { end_col = 1, hl_group = k.sign })
			end
		end
	end

	-- Word-level highlights: pair each run of deletions with the following
	-- run of additions, line by line.
	local i = 1
	while i <= #rows do
		if rows[i].kind == "del" then
			local ds = i
			while i <= #rows and rows[i].kind == "del" do
				i = i + 1
			end
			local as = i
			while i <= #rows and rows[i].kind == "add" do
				i = i + 1
			end
			local pairs_ = math.min(as - ds, i - as)
			for p = 0, pairs_ - 1 do
				local d, a = ds + p, as + p
				local rd, ra = word_diff(rows[d].text, rows[a].text)
				for _, rng in ipairs(rd) do
					vim.api.nvim_buf_set_extmark(buf, ns, d - 1, rng[1] + PREFIX_LEN, {
						end_col = rng[2] + PREFIX_LEN,
						hl_group = "DiffOrigDeleteText",
						priority = 200,
					})
				end
				for _, rng in ipairs(ra) do
					vim.api.nvim_buf_set_extmark(buf, ns, a - 1, rng[1] + PREFIX_LEN, {
						end_col = rng[2] + PREFIX_LEN,
						hl_group = "DiffOrigAddText",
						priority = 200,
					})
				end
			end
		else
			i = i + 1
		end
	end
end

---------------------------------------------------------------------------
-- Command
---------------------------------------------------------------------------
local function diff_orig()
	local src_buf = vim.api.nvim_get_current_buf()
	local src_win = vim.api.nvim_get_current_win()

	local path, err = resolve_file(src_buf)
	if not path then
		return notify(err, vim.log.levels.WARN)
	end

	local old_lines, rerr = read_disk(path, src_buf)
	if not old_lines then
		return notify(rerr, vim.log.levels.ERROR)
	end
	local new_lines = vim.api.nvim_buf_get_lines(src_buf, 0, -1, false)

	if vim.deep_equal(old_lines, new_lines) then
		return notify("No changes: buffer matches file on disk")
	end

	local ok, rows, adds, dels = pcall(build_rows, old_lines, new_lines)
	if not ok then
		return notify("Diff failed: " .. tostring(rows), vim.log.levels.ERROR)
	end
	if #rows == 0 then
		-- e.g. only line-ending / trailing newline differences
		return notify("No content changes (only line endings / EOL differ)")
	end

	-- Reuse an existing DiffOrig window for this buffer if one is open
	local buf_name = "difforig://" .. vim.fn.fnamemodify(path, ":~:.")
	local existing = vim.fn.bufnr(buf_name)
	if existing ~= -1 then
		pcall(vim.api.nvim_buf_delete, existing, { force = true })
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buf, buf_name)
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].filetype = "difforig"
	vim.bo[buf].tabstop = vim.bo[src_buf].tabstop

	render(buf, rows)

	vim.cmd("botright vsplit")
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)
	local wo = vim.wo[win]
	wo.number = false
	wo.relativenumber = false
	wo.signcolumn = "no"
	wo.foldcolumn = "0"
	wo.list = false
	wo.wrap = false
	wo.cursorline = true
	wo.spell = false
	wo.winbar = ("%%#Title# %s %%*  %%#DiffOrigStatAdd#+%d%%*  %%#DiffOrigStatDel#-%d%%*"):format(
		vim.fn.fnamemodify(path, ":~:."):gsub("%%", "%%%%"),
		adds,
		dels
	)

	-- Jump to the first change
	for idx, r in ipairs(rows) do
		if r.kind == "add" or r.kind == "del" then
			vim.api.nvim_win_set_cursor(win, { idx, 0 })
			break
		end
	end

	-- Keymaps
	local map = function(lhs, fn, desc)
		vim.keymap.set("n", lhs, fn, { buffer = buf, nowait = true, silent = true, desc = "DiffOrig: " .. desc })
	end
	local close = function()
		if vim.api.nvim_win_is_valid(win) and #vim.api.nvim_list_wins() > 1 then
			vim.api.nvim_win_close(win, true)
		else
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	end
	map("q", close, "Close")
	map("<Esc>", close, "Close")

	map("<CR>", function()
		local idx = vim.api.nvim_win_get_cursor(0)[1]
		-- Find the nearest row with a new-file line number (search forward then back)
		local target
		for j = idx, #rows do
			if rows[j].new then
				target = rows[j].new
				break
			end
		end
		if not target then
			for j = idx, 1, -1 do
				if rows[j].new then
					target = rows[j].new
					break
				end
			end
		end
		if not vim.api.nvim_buf_is_valid(src_buf) then
			return notify("Source buffer no longer exists", vim.log.levels.WARN)
		end
		if not vim.api.nvim_win_is_valid(src_win) then
			close()
			src_win = vim.api.nvim_get_current_win()
		end
		vim.api.nvim_set_current_win(src_win)
		if vim.api.nvim_win_get_buf(src_win) ~= src_buf then
			vim.api.nvim_win_set_buf(src_win, src_buf)
		end
		local last = vim.api.nvim_buf_line_count(src_buf)
		vim.api.nvim_win_set_cursor(src_win, { math.max(1, math.min(target or 1, last)), 0 })
		vim.cmd("normal! zz")
	end, "Jump to source line")

	-- Start row of every contiguous block of +/- lines
	local block_starts = {}
	local function is_change(r)
		return r and (r.kind == "add" or r.kind == "del")
	end
	for idx, r in ipairs(rows) do
		if is_change(r) and not is_change(rows[idx - 1]) then
			block_starts[#block_starts + 1] = idx
		end
	end

	local function jump_hunk(dir)
		local cur = vim.api.nvim_win_get_cursor(0)[1]
		local from, to = 1, #block_starts
		if dir < 0 then
			from, to = #block_starts, 1
		end
		for j = from, to, dir do
			local s = block_starts[j]
			if (dir > 0 and s > cur) or (dir < 0 and s < cur) then
				vim.api.nvim_win_set_cursor(0, { s, 0 })
				return
			end
		end
		notify(dir > 0 and "No more changes below" or "No more changes above")
	end
	map("]c", function()
		jump_hunk(1)
	end, "Next change")
	map("[c", function()
		jump_hunk(-1)
	end, "Previous change")
end

vim.api.nvim_create_user_command("DiffOrig", diff_orig, { desc = "GitHub-style diff of buffer against file on disk" })

-- Not a plugin; return an empty spec so lazy.nvim accepts it in the plugin list
return {}
