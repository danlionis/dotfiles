-- Sensible Netwr https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/

function NetrwMapping()
    -- vim.notify("mappings working")
    vim.keymap.set("n", "l", "<CR>", { buffer = true, remap = true })
    vim.keymap.set("n", "L", "<CR><cmd>Lexplore<CR>", { buffer = true, remap = true })

    vim.keymap.set("n", "H", "u", { buffer = true, remap = true })
    vim.keymap.set("n", "h", "-^", { buffer = true, remap = true })

    vim.keymap.set("n", "<C-l>", "<C-w>l", { buffer = true, remap = true })

    vim.keymap.set("n", "<TAB>", "mf", { buffer = true, remap = true }) -- Toggle the mark on a file or directory
    vim.keymap.set("n", "<S-TAB>", "mF", { buffer = true, remap = true }) -- Unmark all the files in the current buffer
    vim.keymap.set("n", "<leader><TAB>", "mu", { buffer = true, remap = true }) -- Umark all

    vim.keymap.set("n", "a", "%:w<CR>:buffer #<CR>", { buffer = true, remap = true }) -- Umark all
    vim.keymap.set("n", "A", "d", { buffer = true, remap = true }) -- Umark all

    vim.keymap.set("n", "P", "<C-w>z", { buffer = true, remap = true }) -- Umark all

    vim.keymap.set("n", "fX", "mtmm", { buffer = true, remap = true }) -- Umark all
end

-- [[ netrw mappings ]]
local netrw_mapping = vim.api.nvim_create_augroup('NetrwMapping', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    callback = function()
        NetrwMapping()
    end,
    group = netrw_mapping,
    pattern = 'netrw',
})

vim.g.netrw_liststyle = 3
vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 20
vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = "cp -r"
vim.cmd("hi! link netrwMarkFile Search")
