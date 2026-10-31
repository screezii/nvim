return {
	{
		"folke/tokyonight.nvim",
		lazy = true,
	},
	{
		"marko-cerovac/material.nvim",
		lazy = true,
		config = function()
			vim.g.material_style = "deep ocean"
		end,
	},
	{
		"Mofiqul/dracula.nvim",
		lazy = true,
	},
	{
		"ellisonleao/gruvbox.nvim",
		lazy = true,
		config = function()
			require("gruvbox").setup({
				contrast = "hard",
				palette_overrides = { dark0_hard = "#0E1018" },
				overrides = {
					Comment = { fg = "#81878f", italic = true, bold = true },
					Define = { link = "GruvboxPurple" },
					Macro = { link = "GruvboxPurple" },
					["@constant.builtin"] = { link = "GruvboxPurple" },
					["@storageclass.lifetime"] = { link = "GruvboxAqua" },
					["@text.note"] = { link = "TODO" },
					["@namespace.latex"] = { link = "Include" },
					["@namespace.rust"] = { link = "Include" },
					ContextVt = { fg = "#878788" },
					CopilotSuggestion = { fg = "#878787" },
					CocCodeLens = { fg = "#878787" },
					CocWarningFloat = { fg = "#dfaf87" },
					CocInlayHint = { fg = "#ABB0B6" },
					CocPumShortcut = { fg = "#fe8019" },
					CocPumDetail = { fg = "#fe8019" },
					DiagnosticVirtualTextWarn = { fg = "#dfaf87" },
					-- fold colors
					Folded = { fg = "#fe8019", bg = "#3c3836", italic = true },
					FoldColumn = { fg = "#fe8019", bg = "#0E1018" },
					SignColumn = { bg = "#fe8019" },
					-- git colors
					DiffAdd = { bold = true, reverse = false, fg = "", bg = "#2a4333" },
					DiffChange = { bold = true, reverse = false, fg = "", bg = "#333841" },
					DiffDelete = { bold = true, reverse = false, fg = "#442d30", bg = "#442d30" },
					DiffText = { bold = true, reverse = false, fg = "", bg = "#213352" },
					-- statusline
					-- StatusLine = { bg = "#ffffff", fg = "#0E1018" },
					-- StatusLineNC = { bg = "#ffffff", fg = "#0E1018" },
					CursorLineNr = { fg = "#fabd2f", bg = "" },
					GruvboxOrangeSign = { fg = "#dfaf87", bg = "" },
					GruvboxAquaSign = { fg = "#8EC07C", bg = "" },
					GruvboxGreenSign = { fg = "#b8bb26", bg = "" },
					GruvboxRedSign = { fg = "#fb4934", bg = "" },
					GruvboxBlueSign = { fg = "#83a598", bg = "" },
					WilderMenu = { fg = "#ebdbb2", bg = "" },
					WilderAccent = { fg = "#f4468f", bg = "" },
					-- coc self:mantic token
					CocSemStruct = { link = "GruvboxYellow" },
					CocSemKeyword = { fg = "", bg = "#0E1018" },
					CocSemEnumMember = { fg = "", bg = "#0E1018" },
					CocSemTypeParameter = { fg = "", bg = "#0E1018" },
					CocSemComment = { fg = "", bg = "#0E1018" },
					CocSemMacro = { fg = "", bg = "#0E1018" },
					CocSemVariable = { fg = "", bg = "#0E1018" },
				},
			})
		end,
	},
	{
		"christianchiarulli/nvcode-color-schemes.vim",
		lazy = true,
	},
	{
		"rose-pine/neovim",
		lazy = true,
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				variant = "auto",
				dark_variant = "moon",
				styles = {
					bold = true,
					italic = true,
				},
			})
		end,
	},
	{
		"loctvl842/monokai-pro.nvim",
		config = function()
			require("monokai-pro").setup({
				transparent_background = true,
				filter = "octagon",
			})
		end,
	},
	{
		"GrzegorzSzczepanek/cyberdyne.nvim",
	},
	{
		"soroushsrd/glacier.vim",
		lazy = true,
		priority = 1000,
	},
	{
		"Mofiqul/vscode.nvim",
		lazy = true,
		priority = 1000,
	},
}
