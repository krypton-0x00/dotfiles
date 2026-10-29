-- Git: gitsigns (signs, hunk actions, blame) -------------------------------

return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "▏" },
                topdelete = { text = "▏" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            signs_staged = {
                add = { text = "▍" },
                change = { text = "▍" },
                delete = { text = "▏" },
                topdelete = { text = "▏" },
                changedelete = { text = "▍" },
            },
            signcolumn = true,
            numhl = false,
            linehl = false,
            word_diff = false,
            current_line_blame = false,
            current_line_blame_opts = { virt_text = true, virt_text_pos = "eol", delay = 300 },
            current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> · <summary>",
            update_debounce = 150,
            max_file_length = 20000,
            preview_config = { border = "single", style = "minimal" },
            on_attach = function(buf)
                local gs = require("gitsigns")

                local function map(mode, keys, fn, desc)
                    vim.keymap.set(mode, keys, fn, { buffer = buf, desc = desc, silent = true })
                end

                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gs.nav_hunk("next")
                    end
                end, "Next hunk")

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gs.nav_hunk("prev")
                    end
                end, "Previous hunk")

                map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
                map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
                map("v", "<leader>gs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Stage selection")
                map("v", "<leader>gr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Reset selection")
                map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
                map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
                map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
                map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
                map("n", "<leader>gb", function()
                    gs.blame_line({ full = false })
                end, "Blame line")
                map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle line blame")
                map("n", "<leader>gd", gs.diffthis, "Diff this")
                map("n", "<leader>gD", function()
                    gs.diffthis("~")
                end, "Diff this ~")
                map("n", "<leader>gt", gs.toggle_deleted, "Toggle deleted")
            end,
        },
    },
}
