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
			vim.cmd("highlight " .. group .. " guibg=NONE")
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
