vim.g.mapleader = " "

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- unmap space
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })


vim.keymap.set('n', 'Q', '<Nop>', { silent = true })
vim.keymap.set('n', 'q:', '<Nop>', { silent = true })

-- clear search highlight with ESC
vim.keymap.set({ 'n', 'i' }, '<Esc>', '<cmd>noh<CR><esc>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Move Line
vim.keymap.set("n", "<A-j>", ":m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
-- vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("n", "<A-k>", ":m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
-- vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set("v", "<A-l>", ">gv", { desc = "Indent" })
vim.keymap.set("v", "<A-h>", "<gv", { desc = "De-Indent" })

vim.keymap.set("n", "x", '"_x') -- dont copy to register

-- center page movements
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- copy to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")

-- increment and decrement numbers
vim.keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number under cursor" })
vim.keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number under cursor" })

-- open netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open explorer" })

-- edit and reload init.lua (not possible with lazy)
-- vim.keymap.set("n", "<leader>ve", function(_) vim.api.nvim_command("edit $MYVIMRC") end,
--   { desc = 'Open init.lua file' })
-- vim.keymap.set("n", "<leader>vr", function(_) vim.api.nvim_command("source $MYVIMRC") end,
--   { desc = 'Reload init.lua file' })

-- splits
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window right" })
vim.keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split window down" })
vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Reset split size" })
vim.keymap.set("n", "<leader>wx", ":close<CR>", { desc = "Close current window" })

-- tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", { silent = true, desc = "Open new Tab" })
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", { silent = true, desc = "Close Tab" })
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", { silent = true, desc = "Next Tab" })
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", { silent = true, desc = "Previous Tab" })
vim.keymap.set("n", "<right>", ":tabn<CR>", { silent = true, desc = "Next Buffer" })
vim.keymap.set("n", "<left>", ":tabp<CR>", { silent = true, desc = "Previous Buffer" })

-- -- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)


-- open netrw
-- vim.keymap.set("n", "<leader>e", vim.cmd.Lexplore, { desc = "Open file browser" })

vim.keymap.set("i", "<C-k>", "<Up>", { silent = true, desc = "Move up" })
vim.keymap.set("i", "<C-j>", "<Down>", { silent = true, desc = "Move down" })
vim.keymap.set("i", "<C-h>", "<Left>", { silent = true, desc = "Move left" })
vim.keymap.set("i", "<C-l>", "<Right>", { silent = true, desc = "Move right" })

vim.keymap.set("i", "<C-b>", "<ESC>^i", { silent = true, desc = "Beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", { silent = true, desc = "End of line" })

local conceal_on = true;
vim.keymap.set("n", "<C-e>", function()
    if conceal_on then
        vim.o.conceallevel = 0;
    else
        vim.o.conceallevel = 1;
    end
    conceal_on = not conceal_on
end

)
