return {
    {
        'stevearc/oil.nvim',
        opts = {},
        lazy = false,
        keys = {
            { "-", "<CMD>Oil<CR>", { desc = "Open parent directory", mode = "n" } }
        },
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    }
}
