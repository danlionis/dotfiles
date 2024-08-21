return {
    {
        'mbbill/undotree',
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle, { desc = "Open [u]ndotree" } }
        }
    },

    -- todo comments
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = "BufReadPost",
        config = true,
        -- stylua: igore
        keys = {
            -- TODO: find better keybindings
            { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
            -- { "<leader>xtt", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo Trouble" },
            -- { "<leader>xT", "<cmd>TodoTelescope<cr>",                            desc = "Todo Telescope" },
            { "<leader>st", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "[S]earch [T]odos" },
        },
    },

    {
        "lervag/vimtex",
        ft = { "tex", "bib" },
        config = function()
            vim.g.vimtex_view_general_viewer = "okular"
        end
    },

    -- better diagnostics list and others
    {
        "folke/trouble.nvim",
        enabled = true,
        cmd = { "Trouble", "Trouble" },
        opts = { use_diagnostic_signs = true },
        keys = {
            -- TODO: find better keybindings
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)"
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>xt",
                "<cmd>Trouble todo toggle<cr>",
                desc = "Todos (Trouble)"
            },
            {
                "<leader>xl",
                "<cmd>Trouble lsp toggle focus=false win.position=right win.size=70<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
        },
    },
}
