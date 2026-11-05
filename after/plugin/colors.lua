function ColorCanvas(color, transparent)
	if color then
		vim.cmd("colorscheme " .. color)
	end

	require("custom_hl")

	if transparent == nil then
		transparent = true
	end

	local highlight_groups = {
		"Normal",
		"NormalFloat",
		"NormalNC",
		"NvimTreeNormal",
		"NvimTreeNormalNC",
		"NvimTreeEndOfBuffer",
		"StatusLine",
		"StatusLineNC",
		"SignColumn",
		"WinSeparator",
		"NoicePopup",
		"NoicePopupBorder",
		"NoiceCmdlinePopup",
		"NoiceCmdlinePopupBorder",
		"NoiceConfirm",
		"NoiceConfirmBorder",
		"NoiceVirtualText",
		"NoiceMini",
		"NotifyINFOBorder",
		"NotifyWARNBorder",
		"NotifyERRORBorder",
		"TreesitterContext",
		"TreesitterContextLineNumber",
		"FloatBorder",
		"FloatShadow",
		"FloatShadowThrough",
		"Pmenu",
	}

	local diagnostic_groups = {
		"DiagnosticVirtualTextError",
		"DiagnosticVirtualTextWarn",
		"DiagnosticVirtualTextInfo",
		"DiagnosticVirtualTextHint",
		"DiagnosticVirtualTextOk",
	}

	if transparent then
		for _, group in ipairs(diagnostic_groups) do
			-- resolve the (possibly linked) group so its fg survives; `:hi X guibg=NONE` breaks the link
			local resolved = vim.api.nvim_get_hl(0, { name = group, link = false })
			if resolved.fg == nil then
				local base = vim.api.nvim_get_hl(0, { name = group:gsub("VirtualText", ""), link = false })
				resolved.fg = base.fg
			end
			resolved.bg = nil
			vim.api.nvim_set_hl(0, group, resolved)
		end

		for _, group in ipairs(highlight_groups) do
			vim.api.nvim_set_hl(0, group, { bg = "none" })
		end
	end

	vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000" })
	vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "#808080" })
	vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = true, sp = "#808080" })
end

ColorCanvas("onedark", true)
