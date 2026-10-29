-- Zazzu theme :: dark red on black -----------------------------------------
-- Kept in sync with waybar/style.css, hyprland.lua and dunstrc.

local M = {}

M.palette = {
    bg = "#08080a", -- window background
    bg_soft = "#0f0f12", -- bars, popups, statusline
    bg_high = "#15151a", -- hover / visual blocks
    bg_sel = "#1c1c22", -- selections, folded lines
    border = "#2a2a31", -- 1px separators
    muted = "#4a4a55", -- comments, inactive
    fg_dim = "#8b8b96", -- secondary text
    fg = "#d7d7de", -- body text
    fg_bright = "#f2f2f5", -- headings, cursor line numbers
    red = "#c1121f", -- accent
    red_hi = "#e53946", -- active tag / errors
    red_soft = "#7f0d17", -- deep accent
    red_deep = "#3a0b10", -- dark accent backgrounds
    amber = "#c9973f", -- warnings only
    steel = "#7d8b99", -- info only
}

local p = M.palette

local function hi(group, spec)
    vim.api.nvim_set_hl(0, group, spec)
end

local function link(from, to)
    vim.api.nvim_set_hl(0, from, { link = to })
end

function M.apply()
    vim.opt.termguicolors = true
    vim.opt.background = "dark"
    vim.g.colors_name = "zazzu"

    -- terminal palette -------------------------------------------------------
    vim.g.terminal_color_0 = p.bg
    vim.g.terminal_color_1 = p.red
    vim.g.terminal_color_2 = "#5f8f5f"
    vim.g.terminal_color_3 = p.amber
    vim.g.terminal_color_4 = p.steel
    vim.g.terminal_color_5 = "#8f5f7f"
    vim.g.terminal_color_6 = "#5f8f8f"
    vim.g.terminal_color_7 = p.fg
    vim.g.terminal_color_8 = p.muted
    vim.g.terminal_color_9 = p.red_hi
    vim.g.terminal_color_10 = "#7faf7f"
    vim.g.terminal_color_11 = "#dcb36a"
    vim.g.terminal_color_12 = "#9aa9b8"
    vim.g.terminal_color_13 = "#b08aa0"
    vim.g.terminal_color_14 = "#7fafaf"
    vim.g.terminal_color_15 = p.fg_bright

    -- base ui ----------------------------------------------------------------
    hi("Normal", { fg = p.fg, bg = p.bg })
    hi("NormalNC", { fg = p.fg_dim, bg = p.bg })
    hi("NormalFloat", { fg = p.fg, bg = p.bg_soft })
    hi("FloatBorder", { fg = p.border, bg = p.bg_soft })
    hi("FloatTitle", { fg = p.red_hi, bg = p.bg_soft, bold = true })
    hi("FloatFooter", { fg = p.muted, bg = p.bg_soft })
    hi("Cursor", { fg = p.bg, bg = p.fg_bright })
    hi("lCursor", { fg = p.bg, bg = p.red_hi })
    hi("CursorIM", { fg = p.bg, bg = p.red_hi })
    hi("TermCursor", { fg = p.bg, bg = p.red_hi })
    hi("CursorLine", { bg = p.bg_high })
    hi("CursorColumn", { bg = p.bg_high })
    hi("ColorColumn", { bg = p.bg_soft })
    hi("LineNr", { fg = p.border })
    hi("LineNrAbove", { fg = p.border })
    hi("LineNrBelow", { fg = p.border })
    hi("CursorLineNr", { fg = p.red_hi, bold = true })
    hi("CursorLineSign", { bg = p.bg_high })
    hi("CursorLineFold", { bg = p.bg_high })
    hi("SignColumn", { fg = p.muted, bg = p.bg })
    hi("FoldColumn", { fg = p.muted, bg = p.bg })
    hi("Folded", { fg = p.fg_dim, bg = p.bg_soft })
    hi("VertSplit", { fg = p.border, bg = p.bg })
    hi("WinSeparator", { fg = p.border, bg = p.bg })
    hi("StatusLine", { fg = p.fg, bg = p.bg_soft })
    hi("StatusLineNC", { fg = p.muted, bg = p.bg_soft })
    hi("WinBar", { fg = p.fg_dim, bg = p.bg })
    hi("WinBarNC", { fg = p.muted, bg = p.bg })
    hi("TabLine", { fg = p.fg_dim, bg = p.bg_soft })
    hi("TabLineFill", { fg = p.muted, bg = p.bg_soft })
    hi("TabLineSel", { fg = p.bg, bg = p.red, bold = true })
    hi("Visual", { bg = p.red_deep })
    hi("VisualNOS", { bg = p.bg_sel })
    hi("Search", { fg = p.bg, bg = p.red_hi })
    hi("IncSearch", { fg = p.bg, bg = p.amber })
    hi("CurSearch", { fg = p.bg, bg = p.red_hi, bold = true })
    hi("Substitute", { fg = p.bg, bg = p.amber })
    hi("MatchParen", { fg = p.red_hi, bold = true, underline = true })
    hi("NonText", { fg = p.border })
    hi("SpecialKey", { fg = p.border })
    hi("Whitespace", { fg = p.bg_sel })
    hi("EndOfBuffer", { fg = p.bg })
    hi("Directory", { fg = p.red_hi })
    hi("Title", { fg = p.red_hi, bold = true })
    hi("Conceal", { fg = p.fg_dim })
    hi("QuickFixLine", { bg = p.bg_high })
    hi("Added", { fg = "#6f9f6f" })
    hi("Changed", { fg = p.steel })
    hi("Removed", { fg = p.red_hi })

    -- messages / command line ------------------------------------------------
    hi("MsgArea", { fg = p.fg })
    hi("MsgSeparator", { fg = p.border, bg = p.bg })
    hi("ModeMsg", { fg = p.fg, bold = true })
    hi("MoreMsg", { fg = p.fg_dim })
    hi("Question", { fg = p.fg_dim })
    hi("ErrorMsg", { fg = p.red_hi, bold = true })
    hi("WarningMsg", { fg = p.amber })
    hi("Error", { fg = p.red_hi })
    hi("Todo", { fg = p.bg, bg = p.amber, bold = true })
    hi("Debug", { fg = p.steel })
    hi("Note", { fg = p.steel })

    -- popups -----------------------------------------------------------------
    hi("Pmenu", { fg = p.fg_dim, bg = p.bg_soft })
    hi("PmenuSel", { fg = p.bg, bg = p.red, bold = true })
    hi("PmenuKind", { fg = p.red_hi, bg = p.bg_soft })
    hi("PmenuKindSel", { fg = p.bg, bg = p.red })
    hi("PmenuExtra", { fg = p.muted, bg = p.bg_soft })
    hi("PmenuExtraSel", { fg = p.bg, bg = p.red })
    hi("PmenuSbar", { bg = p.bg_high })
    hi("PmenuThumb", { bg = p.border })
    hi("PmenuMatch", { fg = p.red_hi })
    hi("PmenuMatchSel", { fg = p.bg, bold = true })

    -- syntax -----------------------------------------------------------------
    hi("Comment", { fg = p.muted, italic = true })
    hi("Constant", { fg = "#d98b95" })
    hi("String", { fg = "#b6a9a2" })
    hi("Character", { fg = "#b6a9a2" })
    hi("Number", { fg = "#d98b95" })
    hi("Boolean", { fg = "#d98b95" })
    hi("Float", { fg = "#d98b95" })
    hi("Identifier", { fg = p.fg })
    hi("Function", { fg = p.fg_bright, bold = true })
    hi("Statement", { fg = p.red_hi })
    hi("Conditional", { fg = p.red_hi })
    hi("Repeat", { fg = p.red_hi })
    hi("Label", { fg = p.red_hi })
    hi("Operator", { fg = p.fg_dim })
    hi("Keyword", { fg = p.red_hi })
    hi("Exception", { fg = p.red_hi })
    hi("PreProc", { fg = p.red })
    hi("Include", { fg = p.red })
    hi("Define", { fg = p.red })
    hi("Macro", { fg = p.red })
    hi("PreCondit", { fg = p.red })
    hi("Type", { fg = p.fg_bright })
    hi("StorageClass", { fg = p.red_hi })
    hi("Structure", { fg = p.fg_bright })
    hi("Typedef", { fg = p.fg_bright })
    hi("Special", { fg = p.red_hi })
    hi("SpecialChar", { fg = p.amber })
    hi("Tag", { fg = p.red_hi })
    hi("Delimiter", { fg = p.fg_dim })
    hi("SpecialComment", { fg = p.red })
    hi("Underlined", { fg = p.fg, underline = true })
    hi("Ignore", { fg = p.muted })
    hi("Bold", { bold = true })
    hi("Italic", { italic = true })

    -- treesitter -------------------------------------------------------------
    hi("@variable", { fg = p.fg })
    hi("@variable.builtin", { fg = p.red_hi, italic = true })
    hi("@variable.parameter", { fg = "#c9c2c4" })
    hi("@variable.member", { fg = "#c0b7b9" })
    hi("@property", { fg = "#c0b7b9" })
    hi("@field", { fg = "#c0b7b9" })
    hi("@constant", { fg = "#d98b95" })
    hi("@constant.builtin", { fg = "#d98b95" })
    hi("@constant.macro", { fg = p.red })
    hi("@module", { fg = p.fg_bright })
    hi("@label", { fg = p.red_hi })
    hi("@string", { fg = "#b6a9a2" })
    hi("@string.escape", { fg = p.amber })
    hi("@string.regexp", { fg = p.amber })
    hi("@string.special", { fg = p.amber })
    hi("@string.documentation", { fg = p.fg_dim, italic = true })
    hi("@character", { fg = "#b6a9a2" })
    hi("@number", { fg = "#d98b95" })
    hi("@boolean", { fg = "#d98b95" })
    hi("@float", { fg = "#d98b95" })
    hi("@function", { fg = p.fg_bright, bold = true })
    hi("@function.builtin", { fg = p.red_hi })
    hi("@function.call", { fg = p.fg_bright })
    hi("@function.method", { fg = p.fg_bright })
    hi("@function.macro", { fg = p.red })
    hi("@constructor", { fg = p.fg_bright })
    hi("@keyword", { fg = p.red_hi })
    hi("@keyword.function", { fg = p.red_hi })
    hi("@keyword.operator", { fg = p.fg_dim })
    hi("@keyword.return", { fg = p.red_hi, bold = true })
    hi("@keyword.import", { fg = p.red })
    hi("@keyword.type", { fg = p.red_hi })
    hi("@operator", { fg = p.fg_dim })
    hi("@punctuation", { fg = p.fg_dim })
    hi("@punctuation.bracket", { fg = p.fg_dim })
    hi("@punctuation.delimiter", { fg = p.fg_dim })
    hi("@punctuation.special", { fg = p.red_hi })
    hi("@type", { fg = p.fg_bright })
    hi("@type.builtin", { fg = p.fg_bright, italic = true })
    hi("@type.definition", { fg = p.fg_bright, bold = true })
    hi("@type.qualifier", { fg = p.red_hi })
    hi("@attribute", { fg = p.red })
    hi("@comment", { fg = p.muted, italic = true })
    hi("@comment.documentation", { fg = p.fg_dim, italic = true })
    hi("@comment.error", { fg = p.bg, bg = p.red_hi, bold = true })
    hi("@comment.warning", { fg = p.bg, bg = p.amber, bold = true })
    hi("@comment.todo", { fg = p.bg, bg = p.fg_dim, bold = true })
    hi("@comment.note", { fg = p.bg, bg = p.steel, bold = true })
    hi("@markup.heading", { fg = p.red_hi, bold = true })
    hi("@markup.heading.1", { fg = p.red_hi, bold = true })
    hi("@markup.heading.2", { fg = p.red, bold = true })
    hi("@markup.strong", { bold = true })
    hi("@markup.italic", { italic = true })
    hi("@markup.strikethrough", { strikethrough = true })
    hi("@markup.underline", { underline = true })
    hi("@markup.link", { fg = p.steel, underline = true })
    hi("@markup.link.url", { fg = p.fg_dim, underline = true })
    hi("@markup.raw", { fg = "#b6a9a2" })
    hi("@markup.raw.block", { fg = "#b6a9a2" })
    hi("@markup.list", { fg = p.red_hi })
    hi("@markup.quote", { fg = p.fg_dim, italic = true })
    hi("@diff.plus", { fg = "#6f9f6f" })
    hi("@diff.minus", { fg = p.red_hi })
    hi("@diff.delta", { fg = p.steel })
    hi("@tag", { fg = p.red })
    hi("@tag.attribute", { fg = p.fg_dim })
    hi("@tag.delimiter", { fg = p.muted })

    -- lsp / diagnostics ------------------------------------------------------
    hi("DiagnosticError", { fg = p.red_hi })
    hi("DiagnosticWarn", { fg = p.amber })
    hi("DiagnosticInfo", { fg = p.steel })
    hi("DiagnosticHint", { fg = p.muted })
    hi("DiagnosticOk", { fg = "#6f9f6f" })
    hi("DiagnosticVirtualTextError", { fg = p.red_hi, bg = "#1d0d0f" })
    hi("DiagnosticVirtualTextWarn", { fg = p.amber, bg = "#1a1608" })
    hi("DiagnosticVirtualTextInfo", { fg = p.steel, bg = p.bg_soft })
    hi("DiagnosticVirtualTextHint", { fg = p.muted, bg = p.bg_soft })
    hi("DiagnosticUnderlineError", { undercurl = true, sp = p.red_hi })
    hi("DiagnosticUnderlineWarn", { undercurl = true, sp = p.amber })
    hi("DiagnosticUnderlineInfo", { undercurl = true, sp = p.steel })
    hi("DiagnosticUnderlineHint", { undercurl = true, sp = p.muted })
    hi("DiagnosticFloatingError", { fg = p.red_hi, bg = p.bg_soft })
    hi("DiagnosticFloatingWarn", { fg = p.amber, bg = p.bg_soft })
    hi("DiagnosticFloatingInfo", { fg = p.steel, bg = p.bg_soft })
    hi("DiagnosticFloatingHint", { fg = p.muted, bg = p.bg_soft })
    hi("LspReferenceText", { bg = p.bg_sel })
    hi("LspReferenceRead", { bg = p.bg_sel })
    hi("LspReferenceWrite", { bg = p.bg_sel, underline = true })
    hi("LspSignatureActiveParameter", { fg = p.red_hi, bold = true })
    hi("LspInlayHint", { fg = p.muted, bg = p.bg_soft, italic = true })
    hi("LspCodeLens", { fg = p.muted })
    hi("LspInfoBorder", { fg = p.border, bg = p.bg_soft })

    -- diff / git -------------------------------------------------------------
    hi("DiffAdd", { fg = "#6f9f6f", bg = "#101a13" })
    hi("DiffChange", { fg = p.steel, bg = "#121620" })
    hi("DiffDelete", { fg = p.red_hi, bg = "#1d0d0f" })
    hi("DiffText", { fg = p.fg_bright, bg = "#1d2230" })
    hi("GitSignsAdd", { fg = "#6f9f6f" })
    hi("GitSignsChange", { fg = p.steel })
    hi("GitSignsDelete", { fg = p.red })
    hi("GitSignsTopdelete", { fg = p.red_hi })

    -- statusline blocks (used by zazzu.statusline) ---------------------------
    hi("ZzMode", { fg = p.bg, bg = p.red, bold = true })
    hi("ZzModeInsert", { fg = p.bg, bg = p.fg_bright, bold = true })
    hi("ZzModeVisual", { fg = p.bg, bg = p.amber, bold = true })
    hi("ZzModeReplace", { fg = p.bg, bg = p.red_hi, bold = true })
    hi("ZzModeSelect", { fg = p.bg, bg = p.amber, bold = true })
    hi("ZzModeCommand", { fg = p.bg, bg = p.fg_dim, bold = true })
    hi("ZzBar", { fg = p.fg_dim, bg = p.bg_soft })
    hi("ZzFile", { fg = p.fg, bg = p.bg_soft })
    hi("ZzMod", { fg = p.red_hi, bg = p.bg_soft, bold = true })
    hi("ZzDim", { fg = p.muted, bg = p.bg_soft })
    hi("ZzSep", { fg = p.border, bg = p.bg_soft })
    hi("ZzBranch", { fg = p.red, bg = p.bg_soft })
    hi("ZzErr", { fg = p.red_hi, bg = p.bg_soft })
    hi("ZzWarn", { fg = p.amber, bg = p.bg_soft })
    hi("ZzInfo", { fg = p.steel, bg = p.bg_soft })

    -- misc -------------------------------------------------------------------
    hi("HealthError", { fg = p.red_hi })
    hi("HealthWarning", { fg = p.amber })
    hi("HealthSuccess", { fg = "#6f9f6f" })
    hi("debugPC", { bg = p.bg_soft })
    hi("debugBreakpoint", { fg = p.bg, bg = p.red_hi })

    -- keep links late so plugins inherit the palette
    link("DiagnosticUnnecessary", "Comment")
    link("SpellBad", "DiagnosticUnderlineError")
    link("SpellCap", "DiagnosticUnderlineWarn")
    link("SpellRare", "DiagnosticUnderlineInfo")
end

return M
