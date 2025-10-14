return {
    {
        'Exafunction/codeium.vim',
        enabled = true,
        cmd = 'CodeiumEnable',
        config = function()
            -- Change '<C-g>' here to any keycode you like.
            vim.g.codeium_disable_bindings = 1

            vim.g.filetypes = {
                markdown = false
            }

            vim.keymap.set('i', '<C-a>', function() return vim.fn['codeium#Accept']() end,
                { expr = true, desc = "Codeium Accept" })
            -- vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
            vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
            vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
        end
    }
}
