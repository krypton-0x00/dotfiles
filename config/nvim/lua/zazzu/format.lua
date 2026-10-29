-- Formatting: rustfmt / clang-format / ruff / black / stylua ---------------

local M = {}

local function have(name)
    return vim.fn.executable(name) == 1
end

function M.setup()
    local ok, conform = pcall(require, "conform")
    if not ok then
        return
    end

    conform.setup({
        formatters_by_ft = {
            rust = { "rustfmt" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            cuda = { "clang-format" },
            python = { "ruff_format", "black" }, -- first one available wins
            lua = { "stylua" },
            sh = { "shfmt" },
            bash = { "shfmt" },
        },
        format_on_save = function(bufnr)
            if vim.b[bufnr].zazzu_no_autofmt then
                return nil
            end
            if vim.bo[bufnr].filetype == "python" and not (have("ruff") or have("black")) then
                return nil
            end
            return { timeout_ms = 1500, lsp_format = "fallback" }
        end,
    })

    vim.keymap.set({ "n", "v" }, "<leader>fm", function()
        require("conform").format({ async = true, lsp_format = "fallback" })
    end, { desc = "Format buffer" })
end

return M
