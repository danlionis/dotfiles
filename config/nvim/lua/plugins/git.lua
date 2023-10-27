return {
    -- Git related plugins
    {
        'tpope/vim-fugitive',
        cmd = { "Git", "Gedit", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
        keys = {
            { "<leader>gs", "<cmd>vertical Git<cr>", { desc = "Git Status" } }
        }
    },

    -- open github urls
    {
        'tpope/vim-rhubarb',
        cmd = "GBrowse",
    },

    {
        'lewis6991/gitsigns.nvim',
        event = "BufReadPre",
        opts = {
            signs = {
                -- add = { text = '+' },
                -- change = { text = '~' },
                -- delete = { text = '_' },
                -- topdelete = { text = '‾' },
                -- changedelete = { text = '~' },
            },
            current_line_blame = true
        }
    }
}
