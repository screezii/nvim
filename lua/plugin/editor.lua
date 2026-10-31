return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")
			dashboard.section.header.val = {
				[[                                                                       ]],
				[[  ██████   █████                   █████   █████  ███                  ]],
				[[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
				[[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
				[[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
				[[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
				[[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
				[[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
				[[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
				[[                                                                       ]],
				[[                              Screezii                                ]],
			}

			dashboard.section.buttons.val = {
				dashboard.button("f", "󰈞  Find file", function()
					Snacks.picker.smart()
				end),
				dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("c", "  Configuration", ":e ~/.config/nvim <CR>"),
				dashboard.button("u", "  Update plugins", ":Lazy sync<CR>"),
				dashboard.button("r", "  Recently opened files", function()
					Snacks.picker.recent()
				end),
				dashboard.button("l", "  Open last session", "<cmd>RestoreSession<CR>"),
				dashboard.button("q", "  Quit", ":qa<CR>"),
			}

			local handle, err = io.popen("fortune -s")
			if err or handle == nil then
				dashboard.section.footer.val = "Have Fun"
				alpha.setup(dashboard.opts)
				return
			end
			local fortune = handle:read("*a")
			handle:close()
			dashboard.section.footer.val = fortune
			alpha.setup(dashboard.opts)
		end,
	},
	{
		"cbochs/grapple.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			scope = "git_branch", -- Default to git_branch scope
		},
	},
	{
		"folke/todo-comments.nvim",
		opts = {},
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next Todo Comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous Todo Comment",
			},
			{
				"<localleader>st",
				function()
					Snacks.picker.todo_comments()
				end,
				desc = "Todo Picker",
			},
		},
	},
	{
		"MagicDuck/grug-far.nvim",
		event = "VeryLazy",
		opts = { headerMaxWidth = 80 },
		cmd = "GrugFar",
		keys = {
			{
				"<leader>sR",
				function()
					local grug = require("grug-far")
					local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
					grug.open({
						transient = true,
						prefills = {
							filesFilter = ext and ext ~= "" and "*." .. ext or nil,
						},
					})
				end,
				mode = { "n", "v" },
				desc = "Search and Replace",
			},
		},
	},
	{ "tpope/vim-fugitive" },
	{ "tpope/vim-abolish" },
	{ "djoshea/vim-autoread" },
	{ "wellle/targets.vim" },
	{
		"windwp/nvim-autopairs",
		event = "VeryLazy",
		config = function()
			local autopairs = require("nvim-autopairs")
			autopairs.setup({
				map_cr = false,
				disable_in_visualblock = true,
				check_ts = true,
			})
			local rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")

			autopairs.add_rules({
				rule("$", "$", { "tex", "latex", "md" }):with_cr(cond.none()),
			})

			autopairs.get_rules("`")[1].not_filetypes = { "tex", "latex" }
			autopairs.get_rules("'")[1].not_filetypes = { "tex", "latex" }
		end,
	},
	{ "tpope/vim-surround" },
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,
					lsp_doc_border = false,
				},
				routes = {
					{
						filter = {
							event = "lsp",
							kind = "progress",
							find = "jdtls",
						},
						opts = { skip = true },
					},
				},
			})
		end,
	},
	{
		"folke/trouble.nvim",
		lazy = false,
		cmd = "Trouble",
		config = function()
			require("trouble").setup({})
			vim.diagnostic.config({
				virtual_text = {
					-- source = "always",  -- Or "if_many"
					prefix = "●", -- Could be '■', '▎', 'x'
				},
				severity_sort = true,
				float = {
					source = true,
				},
			})

			-- Automatically open Trouble diagnostics when opening tex/latex files
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = { "*.tex", "*.latex" },
				callback = function()
					-- Wait a bit for LSP/diagnostics to load
					vim.defer_fn(function()
						local diagnostics = vim.diagnostic.get(0)
						if #diagnostics > 0 then
							require("trouble").open("diagnostics")
						end
					end, 500)
				end,
			})
		end,
		keys = {
			{
				"<localleader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
		},
	},
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("gitsigns").setup({
				signcolumn = false,
				status_formatter = function(status)
					local added, changed, removed = status.added, status.changed, status.removed
					local status_txt = {}
					if added and added > 0 then
						table.insert(status_txt, "+" .. added)
					end
					if changed and changed > 0 then
						table.insert(status_txt, "~" .. changed)
					end
					if removed and removed > 0 then
						table.insert(status_txt, "-" .. removed)
					end

					if #status_txt > 1 then
						for i = 2, #status_txt do
							status_txt[i] = "," .. status_txt[i]
						end
					end

					if #status_txt > 2 then
						return string.format("[%s]", table.concat(status_txt))
					else
						return ""
					end
				end,
			})
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({
				git = {
					ignore = false,
				},
				sort = {
					sorter = "case_sensitive",
				},
				disable_netrw = true,
				view = {
					width = 50,
				},
				update_focused_file = {
					enable = true,
					update_root = false,
				},
				actions = {
					open_file = {
						quit_on_open = true,
					},
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = false,
				},
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")

					local function map(mode, key, action, desc)
						vim.keymap.set(mode, key, action, {
							desc = "NvimTree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						})
					end

					api.config.mappings.default_on_attach(bufnr)

					map("n", "s", function()
						local file = api.tree.get_node_under_cursor().absolute_path
						local zathura_installed = os.execute("command -v zathura > /dev/null 2>&1") == 0

						if file:match("%.pdf$") then
							if zathura_installed then
								os.execute('zathura "' .. file .. '" > /dev/null 2>&1 &')
							else
								api.node.open.edit()
							end
						else
							api.node.open.edit()
						end
					end, "Open file or PDF with Zathura (or default editor if not available)")

					map("n", "l", api.node.open.edit, "Open File/Directory")
					map("n", "h", api.node.navigate.parent_close, "Close Directory")
					map("n", "?", api.tree.toggle_help, "Toggle Help") -- Example additional binding
				end,
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},
	{
		"haringsrob/nvim_context_vt",
		event = "VeryLazy",
		config = function()
			require("nvim_context_vt").setup({
				disable_ft = { "rust", "rs" },
				disable_virtual_lines = true,
				min_rows = 8,
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					always_show_tabline = true,
					globalstatus = true,
					refresh = {
						statusline = 100,
						tabline = 100,
						winbar = 100,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = {
						{
							require("noice").api.statusline.mode.get,
							cond = require("noice").api.statusline.mode.has,
							color = { fg = "#ff9e64" },
						},
						"encoding",
						"fileformat",
						"filetype",
					},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			lazygit = {},
			terminal = {},
			picker = {
				win = {
					input = {
						keys = {
							["<M-h>"] = false,
							["<M-.>"] = "toggle_hidden",
						},
					},
					list = {
						keys = {
							["<M-h>"] = false,
							["<M-.>"] = "toggle_hidden",
						},
					},
				},
			},
		},
	},
	{
		"lervag/vimtex",
		init = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_quickfix_mode = 2 -- Auto-open quickfix on errors
			vim.g.vimtex_compiler_latexmk_engines = { ["_"] = "-lualatex -shell-escape" }
			vim.g.vimtex_indent_on_ampersands = 0
			vim.g.matchup_override_vimtex = 1
		end,
	},
	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		opts = {
			picker = "snacks",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		opts = {
			terminal_cmd = "~/.local/bin/claude",
		},
		config = true,
		keys = {
			{ "<localleader>a", nil, desc = "AI/Claude Code" },
			{ "<localleader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<localleader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<localleader>aw", "<C-w>p", desc = "Return to editor" },
			{ "<localleader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<localleader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<localleader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
			{ "<localleader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{
				"<localleader>as",
				"<cmd>ClaudeCodeSend<cr>",
				mode = "v",
				desc = "Send to Claude",
			},
			{
				"<localleader>as",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
			},
			-- Diff management
			{ "<localleader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<localleader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		},
	},
	{
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
		keys = {
			{
				"<M-c>",
				function()
					require("multicursor-nvim").toggleCursor()
				end,
				mode = { "n", "x" },
				desc = "Add/Remove Cursor At Position",
			},
		},
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			mc.addKeymapLayer(function(layerSet)
				layerSet("n", "<esc>", function()
					if not mc.cursorsEnabled() then
						mc.enableCursors()
					else
						mc.clearCursors()
					end
				end)
			end)
		end,
	},
}
