-- Editor defaults: quiet, flat, dwm-ish -----------------------------------

local opt = vim.opt

opt.termguicolors = true
opt.background = "dark"

-- line numbers / gutter
opt.number = true
opt.relativenumber = false
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 6
opt.sidescrolloff = 8
opt.wrap = false
opt.colorcolumn = "" -- set per filetype below

-- indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.shiftround = true

-- search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- ui
opt.laststatus = 3 -- one global bar, like a dwm status bar
opt.showmode = false
opt.ruler = false
opt.cmdheight = 1
opt.shortmess:append("cCIS")
opt.splitright = true
opt.splitbelow = true
opt.pumheight = 12
opt.pumblend = 0
opt.winblend = 0
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " ", fold = " ", vert = "│", horiz = "─" }
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- behaviour
opt.hidden = true
opt.fileencoding = "utf-8"
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.updatetime = 200
opt.timeoutlen = 400
opt.confirm = true
opt.completeopt = { "menuone", "noselect", "noinsert" }

-- dwm-flat: single border for every floating window
if vim.o.winborder ~= nil then
    opt.winborder = "single"
end

-- filetype specific
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "rust", "python" },
    callback = function()
        vim.opt_local.colorcolumn = "100"
        vim.opt_local.textwidth = 100
    end,
})
