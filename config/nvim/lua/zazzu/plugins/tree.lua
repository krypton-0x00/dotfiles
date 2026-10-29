-- File tree: nvim-tree, flat chrome, no icons clutter ------------------------

return {
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "File tree" },
            { "<leader>o", "<cmd>NvimTreeFocus<cr>", desc = "Focus tree" },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- nvim-tree takes over the file browser role
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            require("nvim-tree").setup({
                disable_netrw = true,
                hijack_netrw = true,
                hijack_cursor = true,
                sync_root_with_cwd = true,
                update_focused_file = { enable = true, update_root = false },
                view = {
                    width = 32,
                    side = "left",
                    preserve_window_proportions = false,
                },
                renderer = {
                    highlight_git = true,
                    highlight_opened_files = "name",
                    indent_markers = { enable = true, inline_arrows = false },
                    icons = { show = { file = true, folder = true, git = true } },
                },
                diagnostics = { enable = true, show_on_dirs = true },
                git = { enable = true, ignore = false },
                filters = { dotfiles = false, git_ignored = false },
                actions = { open_file = { quit_on_open = false } },
            })
        end,
    },
}
