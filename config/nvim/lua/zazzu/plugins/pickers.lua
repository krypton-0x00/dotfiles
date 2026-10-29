-- Fuzzy finding: telescope ----------------------------------------------------

return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep project" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
            { "<leader>fr", "<cmd>Telescope resume<cr>", desc = "Resume picker" },
            { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local actions = require("telescope.actions")
            local telescope = require("telescope")

            telescope.setup({
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    color_devicons = false,
                    sorting_strategy = "ascending",
                    layout_config = {
                        prompt_position = "top",
                        horizontal = { preview_width = 0.5 },
                    },
                    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                    mappings = {
                        i = {
                            ["<Esc>"] = actions.close,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<CR>"] = actions.select_default,
                        },
                        n = {
                            ["q"] = actions.close,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                    },
                },
                pickers = {
                    find_files = { hidden = true },
                    buffers = { sort_lastused = true, current_buffer_first = false },
                },
            })
        end,
    },
}
