-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = true

vim.o.cursorline = true

-- Make line numbers default
vim.wo.number = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.smartindent = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.undodir = vim.env.HOME .. "/.cache/vimdid"

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.scrolloff = 8

-- Decrease update time
vim.o.updatetime = 50
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
-- vim.cmd [[colorscheme onedark]]
-- vim.cmd [[colorscheme ghdark]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.o.conceallevel = 1
