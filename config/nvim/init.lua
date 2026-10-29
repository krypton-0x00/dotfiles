-- ============================================================================
--  Zazzu :: Neovim
--  Dark red on black · flat dwm-style chrome · Rust / C / C++ / Python
-- ============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- lazy.nvim bootstrap ---------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({ { "zazzu: failed to clone lazy.nvim", "ErrorMsg" } }, true, {})
    end
end

vim.opt.rtp:prepend(lazypath)

require("zazzu.options")
require("zazzu.keymaps")
require("zazzu.lazy")

vim.cmd.colorscheme("zazzu")

require("zazzu.statusline").setup()
require("zazzu.lsp").setup()
require("zazzu.format").setup()
