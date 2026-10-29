-- Language servers: Rust, C, C++, Python -----------------------------------
-- Uses servers already on the system; nothing is downloaded at runtime.

local M = {}

local extra_paths = {
    vim.fn.expand("~/.local/bin"),
    "/usr/lib/rustup/bin",
    vim.fn.stdpath("data") .. "/mason/bin",
}

local function extend_path()
    local path = vim.env.PATH or ""
    for _, dir in ipairs(extra_paths) do
        if not path:find(dir, 1, true) then
            path = path .. ":" .. dir
        end
    end
    vim.env.PATH = path
end

local function find_exe(name)
    if vim.fn.executable(name) == 1 then
        return vim.fn.exepath(name)
    end
    for _, dir in ipairs(extra_paths) do
        local candidate = dir .. "/" .. name
        if vim.fn.executable(candidate) == 1 then
            return candidate
        end
    end
    return nil
end

local servers = {
    {
        name = "rust_analyzer",
        cmd = { "rust-analyzer" },
        root_markers = { "Cargo.toml", "rust-project.json", "Cargo.lock" },
        filetypes = { "rust" },
        settings = {
            ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                check = { command = "clippy" },
                completion = { autoimport = { enable = true } },
                inlayHints = {
                    closureReturnTypeHints = { enable = "with_block" },
                    lifetimeElisionHints = { enable = "skip_trivial" },
                },
            },
        },
    },
    {
        name = "clangd",
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never" },
        root_markers = {
            "compile_commands.json",
            "compile_flags.txt",
            ".clangd",
            "Makefile",
            ".git",
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    },
    {
        name = "pyright",
        cmd = { "pyright-langserver", "--stdio" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
        filetypes = { "python" },
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "basic",
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "openFilesOnly",
                },
            },
        },
    },
}

local function on_attach(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
        return
    end

    local buf = args.buf

    local function map(keys, fn, desc)
        vim.keymap.set("n", keys, fn, { buffer = buf, desc = desc, silent = true })
    end

    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gi", vim.lsp.buf.implementation, "Go to implementation")
    map("gt", vim.lsp.buf.type_definition, "Go to type definition")
    map("gr", vim.lsp.buf.references, "References")
    map("K", vim.lsp.buf.hover, "Hover")
    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
    map("<leader>cl", vim.lsp.codelens.run, "Run code lens")
    map("[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
    end, "Previous diagnostic")
    map("]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
    end, "Next diagnostic")
    map("<leader>ih", function()
        vim.lsp.inlay_hint.enable(
            not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }),
            { bufnr = buf }
        )
    end, "Toggle inlay hints")

    -- Semantic tokens are enabled by default since 0.11; make it explicit here.
    if client:supports_method("textDocument/semanticTokens/full") then
        pcall(vim.lsp.semantic_tokens.enable, true, { bufnr = buf })
    end
end

function M.setup()
    extend_path()

    vim.diagnostic.config({
        virtual_text = { spacing = 2, prefix = "●", source = "if_many" },
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "E",
                [vim.diagnostic.severity.WARN] = "W",
                [vim.diagnostic.severity.INFO] = "I",
                [vim.diagnostic.severity.HINT] = "H",
            },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "single", source = true, header = "", prefix = "" },
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
    end

    vim.lsp.config("*", { capabilities = capabilities })

    local enabled = {}
    for _, server in ipairs(servers) do
        local binary = find_exe(server.cmd[1])
        if binary then
            local config = vim.deepcopy(server)
            config.name = nil
            config.cmd = vim.list_extend({ binary }, { unpack(server.cmd, 2) })
            vim.lsp.config(server.name, config)
            enabled[#enabled + 1] = server.name
        else
            vim.notify(
                ("zazzu: %s not found on PATH, %s support disabled"):format(
                    server.cmd[1],
                    server.filetypes[1]
                ),
                vim.log.levels.WARN
            )
        end
    end

    if #enabled > 0 then
        vim.lsp.enable(enabled)
    end

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("zazzu_lsp_attach", { clear = true }),
        callback = on_attach,
    })
end

return M
