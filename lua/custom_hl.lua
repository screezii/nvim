local c = {
	white = "#abb2bf",
	darker_black = "#1b1f27",
	black = "#0d0f15",
	black2 = "#252931",
	one_bg = "#282c34",
	one_bg2 = "#353b45",
	one_bg3 = "#373b43",
	grey = "#42464e",
	grey_fg = "#565c64",
	grey_fg2 = "#6f737b",
	light_grey = "#6f737b",
	red = "#e06c75",
	baby_pink = "#DE8C92",
	pink = "#ff75a0",
	line = "#31353d",
	green = "#98c379",
	vibrant_green = "#7eca9c",
	nord_blue = "#81A1C1",
	blue = "#61afef",
	yellow = "#e7c787",
	sun = "#EBCB8B",
	purple = "#de98fd",
	dark_purple = "#c882e7",
	teal = "#519ABA",
	orange = "#fca2aa",
	cyan = "#a3b8ef",
	pmenu_bg = "#61afef",
	folder_bg = "#61afef",
}

local t = {
	base00 = "#0d0f15",
	base01 = "#353b45",
	base02 = "#3e4451",
	base03 = "#545862",
	base04 = "#565c64",
	base05 = "#abb2bf",
	base06 = "#b6bdca",
	base07 = "#c8ccd4",
	base08 = "#e06c75",
	base09 = "#d19a66",
	base0A = "#e5c07b",
	base0B = "#98c379",
	base0C = "#56b6c2",
	base0D = "#61afef",
	base0E = "#c678dd",
	base0F = "#be5046",
}

local hl = vim.api.nvim_set_hl

-- defaults
hl(0, "Added", { fg = c.green })
hl(0, "Removed", { fg = c.red })
hl(0, "Changed", { fg = c.yellow })
hl(0, "MatchWord", { bg = c.grey, fg = c.white })
hl(0, "Pmenu", { bg = c.one_bg })
hl(0, "PmenuSbar", { bg = c.one_bg })
hl(0, "PmenuSel", { bg = c.pmenu_bg, fg = c.black })
hl(0, "PmenuThumb", { bg = c.grey })
hl(0, "MatchParen", { link = "MatchWord" })
hl(0, "Comment", { fg = c.light_grey })
hl(0, "CursorLineNr", { fg = c.white })
hl(0, "LineNr", { fg = c.grey })
hl(0, "FloatBorder", { fg = c.blue })
hl(0, "FloatTitle", { fg = c.white, bg = c.grey })
hl(0, "NormalFloat", { bg = c.darker_black })
hl(0, "NvimInternalError", { fg = c.red })
hl(0, "WinSeparator", { fg = c.line })
hl(0, "Normal", { fg = t.base05, bg = t.base00 })
hl(0, "DevIconDefault", { fg = c.red })
hl(0, "Debug", { fg = t.base08 })
hl(0, "Directory", { fg = t.base0D })
hl(0, "Error", { fg = t.base00, bg = t.base08 })
hl(0, "ErrorMsg", { fg = t.base08, bg = t.base00 })
hl(0, "Exception", { fg = t.base08 })
hl(0, "FoldColumn", { bg = "none" })
hl(0, "Folded", { fg = c.light_grey, bg = c.black2 })
hl(0, "IncSearch", { fg = t.base01, bg = t.base09 })
hl(0, "Macro", { fg = t.base08 })
hl(0, "ModeMsg", { fg = t.base0B })
hl(0, "MoreMsg", { fg = t.base0B })
hl(0, "Question", { fg = t.base0D })
hl(0, "Search", { fg = t.base01, bg = t.base0A })
hl(0, "Substitute", { fg = t.base01, bg = t.base0A })
hl(0, "SpecialKey", { fg = t.base03 })
hl(0, "TooLong", { fg = t.base08 })
hl(0, "Visual", { bg = t.base02 })
hl(0, "VisualNOS", { fg = t.base08 })
hl(0, "WarningMsg", { fg = t.base08 })
hl(0, "WildMenu", { fg = t.base08, bg = t.base0A })
hl(0, "Title", { fg = t.base0D })
hl(0, "Conceal", { bg = "NONE" })
hl(0, "Cursor", { fg = t.base00, bg = t.base05 })
hl(0, "NonText", { fg = t.base03 })
hl(0, "SignColumn", { fg = t.base03 })
hl(0, "ColorColumn", { bg = c.black2 })
hl(0, "CursorColumn", { bg = t.base01 })
hl(0, "CursorLine", { bg = c.black2 })
hl(0, "QuickFixLine", { bg = t.base01 })
hl(0, "healthSuccess", { bg = c.green, fg = c.black })
hl(0, "WinBar", { bg = "NONE" })
hl(0, "WinBarNC", { bg = "NONE" })

-- lazy.nvim
hl(0, "LazyH1", { bg = c.green, fg = c.black })
hl(0, "LazyButton", { bg = c.one_bg, fg = "#888c94" })
hl(0, "LazyH2", { fg = c.red, bold = true, underline = true })
hl(0, "LazyReasonPlugin", { fg = c.red })
hl(0, "LazyValue", { fg = c.teal })
hl(0, "LazyDir", { fg = t.base05 })
hl(0, "LazyUrl", { fg = t.base05 })
hl(0, "LazyCommit", { fg = c.green })
hl(0, "LazyNoCond", { fg = c.red })
hl(0, "LazySpecial", { fg = c.blue })
hl(0, "LazyReasonFt", { fg = c.purple })
hl(0, "LazyOperator", { fg = c.white })
hl(0, "LazyReasonKeys", { fg = c.teal })
hl(0, "LazyTaskOutput", { fg = c.white })
hl(0, "LazyCommitIssue", { fg = c.pink })
hl(0, "LazyReasonEvent", { fg = c.yellow })
hl(0, "LazyReasonStart", { fg = c.white })
hl(0, "LazyReasonRuntime", { fg = c.nord_blue })
hl(0, "LazyReasonCmd", { fg = c.sun })
hl(0, "LazyReasonSource", { fg = c.cyan })
hl(0, "LazyReasonImport", { fg = c.white })
hl(0, "LazyProgressDone", { fg = c.green })

-- syntax
hl(0, "Boolean", { fg = t.base09 })
hl(0, "Character", { fg = t.base08 })
hl(0, "Conditional", { fg = t.base0E })
hl(0, "Constant", { fg = t.base09 })
hl(0, "Define", { fg = t.base0E })
hl(0, "Delimiter", { fg = t.base0F })
hl(0, "Float", { fg = t.base09 })
hl(0, "Variable", { fg = t.base05 })
hl(0, "Function", { fg = t.base0D })
hl(0, "Identifier", { fg = t.base08 })
hl(0, "Include", { fg = t.base0D })
hl(0, "Keyword", { fg = t.base0E })
hl(0, "Label", { fg = t.base0A })
hl(0, "Number", { fg = t.base09 })
hl(0, "Operator", { fg = t.base05 })
hl(0, "PreProc", { fg = t.base0A })
hl(0, "Repeat", { fg = t.base0A })
hl(0, "Special", { fg = t.base0C })
hl(0, "SpecialChar", { fg = t.base0F })
hl(0, "Statement", { fg = t.base08 })
hl(0, "StorageClass", { fg = t.base0A })
hl(0, "String", { fg = t.base0B })
hl(0, "Structure", { fg = t.base0E })
hl(0, "Tag", { fg = t.base0A })
hl(0, "Todo", { fg = t.base0A, bg = t.base01 })
hl(0, "Type", { fg = t.base0A })
hl(0, "Typedef", { fg = t.base0A })

-- treesitter
hl(0, "@variable", { fg = t.base05 })
hl(0, "@variable.builtin", { fg = t.base09 })
hl(0, "@variable.parameter", { fg = t.base08 })
hl(0, "@variable.member", { fg = t.base08 })
hl(0, "@variable.member.key", { fg = t.base08 })
hl(0, "@module", { fg = t.base08 })
hl(0, "@constant", { fg = t.base09 })
hl(0, "@constant.builtin", { fg = t.base09 })
hl(0, "@constant.macro", { fg = t.base08 })
hl(0, "@string", { fg = t.base0B })
hl(0, "@string.regex", { fg = t.base0C })
hl(0, "@string.escape", { fg = t.base0C })
hl(0, "@character", { fg = t.base08 })
hl(0, "@number", { fg = t.base09 })
hl(0, "@number.float", { fg = t.base09 })
hl(0, "@annotation", { fg = t.base0F })
hl(0, "@attribute", { fg = t.base0A })
hl(0, "@error", { fg = t.base08 })
hl(0, "@keyword.exception", { fg = t.base08 })
hl(0, "@keyword", { fg = t.base0E })
hl(0, "@keyword.function", { fg = t.base0E })
hl(0, "@keyword.return", { fg = t.base0E })
hl(0, "@keyword.operator", { fg = t.base0E })
hl(0, "@keyword.import", { link = "Include" })
hl(0, "@keyword.conditional", { fg = t.base0E })
hl(0, "@keyword.conditional.ternary", { fg = t.base0E })
hl(0, "@keyword.repeat", { fg = t.base0A })
hl(0, "@keyword.storage", { fg = t.base0A })
hl(0, "@keyword.directive.define", { fg = t.base0E })
hl(0, "@keyword.directive", { fg = t.base0A })
hl(0, "@function", { fg = t.base0D })
hl(0, "@function.builtin", { fg = t.base0D })
hl(0, "@function.macro", { fg = t.base08 })
hl(0, "@function.call", { fg = t.base0D })
hl(0, "@function.method", { fg = t.base0D })
hl(0, "@function.method.call", { fg = t.base0D })
hl(0, "@constructor", { fg = t.base0C })
hl(0, "@operator", { fg = t.base05 })
hl(0, "@reference", { fg = t.base05 })
hl(0, "@punctuation.bracket", { fg = t.base0F })
hl(0, "@punctuation.delimiter", { fg = t.base0F })
hl(0, "@symbol", { fg = t.base0B })
hl(0, "@tag", { fg = t.base0A })
hl(0, "@tag.attribute", { fg = t.base08 })
hl(0, "@tag.delimiter", { fg = t.base0F })
hl(0, "@text", { fg = t.base05 })
hl(0, "@text.emphasis", { fg = t.base09 })
hl(0, "@text.strike", { fg = t.base0F, strikethrough = true })
hl(0, "@type.builtin", { fg = t.base0A })
hl(0, "@definition", { sp = t.base04, underline = true })
hl(0, "@scope", { bold = true })
hl(0, "@property", { fg = t.base08 })
hl(0, "@markup.heading", { fg = t.base0D })
hl(0, "@markup.raw", { fg = t.base09 })
hl(0, "@markup.link", { fg = t.base08 })
hl(0, "@markup.link.url", { fg = t.base09, underline = true })
hl(0, "@markup.link.label", { fg = t.base0C })
hl(0, "@markup.list", { fg = t.base08 })
hl(0, "@markup.strong", { bold = true })
hl(0, "@markup.underline", { underline = true })
hl(0, "@markup.italic", { italic = true })
hl(0, "@markup.strikethrough", { strikethrough = true })
hl(0, "@markup.quote", { bg = c.black2 })
hl(0, "@comment", { fg = c.grey_fg })
hl(0, "@comment.todo", { fg = c.grey, bg = c.white })
hl(0, "@comment.warning", { fg = c.black2, bg = t.base09 })
hl(0, "@comment.note", { fg = c.black, bg = c.blue })
hl(0, "@comment.danger", { fg = c.black2, bg = c.red })
hl(0, "@diff.plus", { fg = c.green })
hl(0, "@diff.minus", { fg = c.red })
hl(0, "@diff.delta", { fg = c.light_grey })

-- LSP
hl(0, "LspReferenceText", { bg = c.one_bg3 })
hl(0, "LspReferenceRead", { bg = c.one_bg3 })
hl(0, "LspReferenceWrite", { bg = c.one_bg3 })
hl(0, "DiagnosticHint", { fg = c.purple })
hl(0, "DiagnosticError", { fg = c.red })
hl(0, "DiagnosticWarn", { fg = c.yellow })
hl(0, "DiagnosticInfo", { fg = c.green })
hl(0, "LspSignatureActiveParameter", { fg = c.black, bg = c.green })
hl(0, "LspInlayHint", { bg = c.black2, fg = c.light_grey })

-- nvim-cmp
hl(0, "CmpItemAbbr", { fg = c.white })
hl(0, "CmpItemAbbrMatch", { fg = c.blue, bold = true })
hl(0, "CmpDoc", { bg = c.black })
hl(0, "CmpDocBorder", { fg = c.grey_fg })
hl(0, "CmpPmenu", { bg = c.black })
hl(0, "CmpSel", { link = "PmenuSel", bold = true })
hl(0, "CmpBorder", { fg = c.grey_fg })
hl(0, "CmpItemKindConstant", { fg = t.base09 })
hl(0, "CmpItemKindFunction", { fg = t.base0D })
hl(0, "CmpItemKindIdentifier", { fg = t.base08 })
hl(0, "CmpItemKindField", { fg = t.base08 })
hl(0, "CmpItemKindVariable", { fg = t.base0E })
hl(0, "CmpItemKindSnippet", { fg = c.red })
hl(0, "CmpItemKindText", { fg = t.base0B })
hl(0, "CmpItemKindStructure", { fg = t.base0E })
hl(0, "CmpItemKindType", { fg = t.base0A })
hl(0, "CmpItemKindKeyword", { fg = t.base07 })
hl(0, "CmpItemKindMethod", { fg = t.base0D })
hl(0, "CmpItemKindConstructor", { fg = c.blue })
hl(0, "CmpItemKindFolder", { fg = t.base07 })
hl(0, "CmpItemKindModule", { fg = t.base0A })
hl(0, "CmpItemKindProperty", { fg = t.base08 })
hl(0, "CmpItemKindEnum", { fg = c.blue })
hl(0, "CmpItemKindUnit", { fg = t.base0E })
hl(0, "CmpItemKindClass", { fg = c.teal })
hl(0, "CmpItemKindFile", { fg = t.base07 })
hl(0, "CmpItemKindInterface", { fg = c.green })
hl(0, "CmpItemKindColor", { fg = c.white })
hl(0, "CmpItemKindReference", { fg = t.base05 })
hl(0, "CmpItemKindEnumMember", { fg = c.purple })
hl(0, "CmpItemKindStruct", { fg = t.base0E })
hl(0, "CmpItemKindValue", { fg = c.cyan })
hl(0, "CmpItemKindEvent", { fg = c.yellow })
hl(0, "CmpItemKindOperator", { fg = t.base05 })
hl(0, "CmpItemKindTypeParameter", { fg = t.base08 })
hl(0, "CmpItemKindCopilot", { fg = c.green })

-- nvim-tree
hl(0, "NvimTreeEmptyFolderName", { fg = c.folder_bg })
hl(0, "NvimTreeEndOfBuffer", { fg = c.darker_black })
hl(0, "NvimTreeFolderIcon", { fg = c.folder_bg })
hl(0, "NvimTreeFolderName", { fg = c.folder_bg })
hl(0, "NvimTreeFolderArrowOpen", { fg = c.folder_bg })
hl(0, "NvimTreeFolderArrowClosed", { fg = c.grey_fg })
hl(0, "NvimTreeGitDirty", { fg = c.red })
hl(0, "NvimTreeIndentMarker", { fg = c.line })
hl(0, "NvimTreeNormal", { bg = c.darker_black })
hl(0, "NvimTreeNormalNC", { bg = c.darker_black })
hl(0, "NvimTreeOpenedFolderName", { fg = c.folder_bg })
hl(0, "NvimTreeGitIgnored", { fg = c.light_grey })
hl(0, "NvimTreeDiagnosticErrorFileHL", { link = "DiagnosticError" })
hl(0, "NvimTreeDiagnosticErrorFolderHL", { link = "DiagnosticError" })
hl(0, "NvimTreeDiagnosticInfoFileHL", { link = "DiagnosticNormal" })
hl(0, "NvimTreeDiagnosticInfoFolderHL", { link = "DiagnosticNormal" })
hl(0, "NvimTreeDiagnosticWarnFileHL", { link = "DiagnosticWarn" })
hl(0, "NvimTreeDiagnosticWarnFolderHL", { link = "DiagnosticWarn" })
hl(0, "NvimTreeDiagnosticHintFileHL", { link = "DiagnosticHint" })
hl(0, "NvimTreeDiagnosticHintFolderHL", { link = "DiagnosticHint" })
hl(0, "NvimTreeWinSeparator", { fg = c.darker_black, bg = c.darker_black })
hl(0, "NvimTreeWindowPicker", { fg = c.red, bg = c.black2 })
hl(0, "NvimTreeCursorLine", { bg = c.black })
hl(0, "NvimTreeGitNew", { fg = c.yellow })
hl(0, "NvimTreeGitDeleted", { fg = c.red })
hl(0, "NvimTreeSpecialFile", { fg = c.yellow, bold = true })
hl(0, "NvimTreeRootFolder", { fg = c.red, bold = true })

-- mason
hl(0, "MasonHeader", { bg = c.red, fg = c.black })
hl(0, "MasonHighlight", { fg = c.blue })
hl(0, "MasonHighlightBlock", { fg = c.black, bg = c.green })
hl(0, "MasonHighlightBlockBold", { link = "MasonHighlightBlock" })
hl(0, "MasonHeaderSecondary", { link = "MasonHighlightBlock" })
hl(0, "MasonMuted", { fg = c.light_grey })
hl(0, "MasonMutedBlock", { fg = c.light_grey, bg = c.one_bg })

-- git diff (precomputed: mix(color, black=#1e222a, 90))
hl(0, "diffOldFile", { fg = c.baby_pink })
hl(0, "diffNewFile", { fg = c.blue })
hl(0, "DiffAdd", { bg = "#2a3231", fg = c.green })
hl(0, "DiffAdded", { bg = "#2a3231", fg = c.green })
hl(0, "DiffChange", { bg = "#262a32", fg = c.light_grey })
hl(0, "DiffChangeDelete", { bg = "#312931", fg = c.red })
hl(0, "DiffModified", { bg = "#342e36", fg = c.orange })
hl(0, "DiffDelete", { bg = "#312931", fg = c.red })
hl(0, "DiffRemoved", { bg = "#312931", fg = c.red })
hl(0, "DiffText", { fg = c.white, bg = c.black2 })
hl(0, "gitcommitOverflow", { fg = t.base08 })
hl(0, "gitcommitSummary", { fg = t.base0B })
hl(0, "gitcommitComment", { fg = t.base03 })
hl(0, "gitcommitUntracked", { fg = t.base03 })
hl(0, "gitcommitDiscarded", { fg = t.base03 })
hl(0, "gitcommitSelected", { fg = t.base03 })
hl(0, "gitcommitHeader", { fg = t.base0E })
hl(0, "gitcommitSelectedType", { fg = t.base0D })
hl(0, "gitcommitUnmergedType", { fg = t.base0D })
hl(0, "gitcommitDiscardedType", { fg = t.base0D })
hl(0, "gitcommitBranch", { fg = t.base09, bold = true })
hl(0, "gitcommitUntrackedFile", { fg = t.base0A })
hl(0, "gitcommitUnmergedFile", { fg = t.base08, bold = true })
hl(0, "gitcommitDiscardedFile", { fg = t.base08, bold = true })
hl(0, "gitcommitSelectedFile", { fg = t.base0B, bold = true })
