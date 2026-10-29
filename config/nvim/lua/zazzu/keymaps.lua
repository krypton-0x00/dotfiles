local map = vim.keymap.set

-- files ------------------------------------------------------------------
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit all (force)" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- telescope --------------------------------------------------------------
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Grep project" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>fr", "<cmd>Telescope resume<cr>", { desc = "Resume picker" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })

-- tree -------------------------------------------------------------------
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "File tree" })
map("n", "<leader>o", "<cmd>NvimTreeFocus<cr>", { desc = "Focus tree" })

-- buffers ----------------------------------------------------------------
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- windows ----------------------------------------------------------------
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-Up>", "<cmd>resize -2<cr>", { desc = "Shrink height" })
map("n", "<C-Down>", "<cmd>resize +2<cr>", { desc = "Grow height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Shrink width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Grow width" })

-- lines ------------------------------------------------------------------
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
map("n", "J", "mzJ`z", { desc = "Join line, keep cursor" })

-- terminal ---------------------------------------------------------------
map("n", "<leader>tt", "<cmd>split | terminal<cr>", { desc = "Terminal split" })
map("n", "<leader>tv", "<cmd>vsplit | terminal<cr>", { desc = "Terminal vsplit" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Leave terminal mode" })
