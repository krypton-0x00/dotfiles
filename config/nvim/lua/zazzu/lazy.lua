require("lazy").setup({
    spec = { { import = "zazzu.plugins" } },

    defaults = { lazy = true, version = false },
    install = { colorscheme = { "zazzu", "habamax" } },
    checker = { enabled = false },
    change_detection = { enabled = true, notify = false },
    ui = { border = "single" },

    performance = {
        rtp = {
            disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
        },
    },
})
