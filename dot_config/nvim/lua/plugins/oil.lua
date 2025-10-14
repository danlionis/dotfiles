return {
    {
        'stevearc/oil.nvim',
        opts = {
            keymaps = {
                ["<C-p>"] = false,
            }
        },
        lazy = false,
        keys = {
            { "-", "<CMD>Oil<CR>", { desc = "Open parent directory", mode = "n" } }
        },
        config = function(_, opts)
            require("oil").setup(opts)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "oil_preview",
                callback = function(params)
                    vim.keymap.set("n", "<CR>", "o", { buffer = params.buf, remap = true, nowait = true })
                end,
            })
        end,
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    }
}
