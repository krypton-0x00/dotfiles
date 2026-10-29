-- Flat dwm-style statusline: one bar, blocks, no powerline glyphs -----------

local M = {}

local modes = {
    n = { " NORMAL ", "ZzMode" },
    i = { " INSERT ", "ZzModeInsert" },
    v = { " VISUAL ", "ZzModeVisual" },
    V = { " V-LINE ", "ZzModeVisual" },
    ["\22"] = { " V-BLOCK ", "ZzModeVisual" }, -- <C-v>
    s = { " SELECT ", "ZzModeSelect" },
    S = { " S-LINE ", "ZzModeSelect" },
    ["\19"] = { " S-BLOCK ", "ZzModeSelect" }, -- <C-s>
    R = { " REPLACE ", "ZzModeReplace" },
    r = { " REPLACE ", "ZzModeReplace" },
    ["!"] = { " SHELL ", "ZzModeCommand" },
    t = { " TERM ", "ZzModeCommand" },
    c = { " COMMAND ", "ZzModeCommand" },
}

local function escape(text)
    return (text:gsub("%%", "%%%%"))
end

local function mode_block()
    local m = vim.api.nvim_get_mode().mode
    local first = m:sub(1, 1)
    local entry = modes[m] or modes[first] or modes.n
    return entry[1], entry[2]
end

local function diagnostics(buf)
    local out = ""

    local ok, counts = pcall(vim.diagnostic.count, buf)
    if not ok or type(counts) ~= "table" then
        return out
    end

    local errors = counts[vim.diagnostic.severity.ERROR] or 0
    local warnings = counts[vim.diagnostic.severity.WARN] or 0

    if errors > 0 then
        out = out .. "%#ZzErr#  E" .. errors .. " "
    end
    if warnings > 0 then
        out = out .. "%#ZzWarn#  W" .. warnings .. " "
    end
    return out
end

function M.render()
    local buf = vim.api.nvim_get_current_buf()

    local name = vim.api.nvim_buf_get_name(buf)
    local file = name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":~:.")
    local modified = vim.bo[buf].modified and " +" or ""
    local filetype = vim.bo[buf].filetype ~= "" and vim.bo[buf].filetype or "text"

    local mode, mode_hl = mode_block()

    local branch = vim.b[buf].gitsigns_head or ""
    local branch_block = branch ~= "" and ("%#ZzSep#│%#ZzBranch#  " .. escape(branch) .. " ")
        or ""

    local line = vim.fn.line(".")
    local column = vim.fn.col(".")
    local total = vim.fn.line("$")
    local percent = total > 0 and math.floor(line * 100 / total) or 0

    local left = "%#"
        .. mode_hl
        .. "#"
        .. mode
        .. "%#ZzFile# "
        .. escape(file)
        .. "%#ZzMod#"
        .. modified
        .. "%#ZzBar# "

    local right = branch_block
        .. diagnostics(buf)
        .. "%#ZzSep#│%#ZzBar# "
        .. filetype
        .. " "
        .. "%#ZzDim#"
        .. percent
        .. "%% "
        .. "%#ZzSep#│%#ZzBar# "
        .. line
        .. ":"
        .. column
        .. " "

    return left .. "%=" .. right
end

function M.setup()
    -- %{%...%} re-evaluates the returned string, so %#Group# blocks work
    vim.o.statusline = "%{%v:lua.require'zazzu.statusline'.render()%}"
end

return M
