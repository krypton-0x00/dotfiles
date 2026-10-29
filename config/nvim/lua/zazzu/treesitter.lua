-- Treesitter: highlighter + indentation for the supported languages ----------
-- Parsers are installed into stdpath('data')/site; missing ones are fetched in
-- the background on first start (needs the tree-sitter CLI or a C compiler).

local M = {}

local parsers = {
    -- toolchains this config targets
    "rust",
    "c",
    "cpp",
    "python",
    -- editor's own languages
    "lua",
    "vim",
    "vimdoc",
    "query",
    -- writing / config files
    "markdown",
    "markdown_inline",
    "toml",
    "json",
    "yaml",
    "bash",
}

local function build_tools()
    return vim.fn.executable("tree-sitter") == 1
        or vim.fn.executable("cc") == 1
        or vim.fn.executable("gcc") == 1
end

local function start(buf)
    if not pcall(vim.treesitter.start, buf) then
        return
    end
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

function M.setup()
    local ok, ts = pcall(require, "nvim-treesitter")
    if not ok then
        return
    end

    ts.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })

    -- Highlight / indent every buffer whose parser is available. Core Neovim
    -- ships the queries, so no extra setup call is needed.
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("zazzu_treesitter", { clear = true }),
        callback = function(event)
            start(event.buf)
        end,
    })

    if not build_tools() then
        return
    end

    local installed = ts.get_installed("parsers")
    local missing = {}
    for _, lang in ipairs(parsers) do
        if not vim.tbl_contains(installed, lang) then
            missing[#missing + 1] = lang
        end
    end

    if #missing == 0 then
        return
    end

    -- Async: never block startup, and stay quiet when we are offline.
    vim.schedule(function()
        local job = ts.install(missing)
        if job == nil then
            return
        end
        vim.notify(
            "zazzu: installing treesitter parsers (" .. table.concat(missing, ", ") .. ")",
            vim.log.levels.INFO
        )
    end)
end

return M
