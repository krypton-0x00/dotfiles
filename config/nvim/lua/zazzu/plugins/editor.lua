-- Editor chrome: treesitter, autopairs, which-key, format on save ----------

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("zazzu.treesitter").setup()
        end,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = { check_ts = true, fast_wrap = {} },
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "classic",
            icons = { mappings = false },
            win = { border = "single", padding = { 1, 2 } },
            layout = { spacing = 2 },
        },
    },

    {
        "stevearc/conform.nvim",
        lazy = false,
        cmd = { "ConformInfo" },
    },
}
