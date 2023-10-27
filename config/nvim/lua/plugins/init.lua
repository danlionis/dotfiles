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
        -- stylua: ignore
        keys = {
            -- TODO: find better keybindings
            { "]t",          function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t",          function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
            { "<leader>xt",  "<cmd>TodoTrouble<cr>",                              desc = "Todo Trouble" },
            { "<leader>xtt", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo Trouble" },
            { "<leader>xT",  "<cmd>TodoTelescope<cr>",                            desc = "Todo Telescope" },
            { "<leader>st",  "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "[S]earch [T]odos" },
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
    -- NOTE: maybe we can remove this, does not seem too useful
    {
        "folke/trouble.nvim",
        enabled = true,
        cmd = { "TroubleToggle", "Trouble" },
        opts = { use_diagnostic_signs = true },
        keys = {
            -- TODO: find better keybindings
            -- { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics (Trouble)" },
            { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Workspace Diagnostics (Trouble)" },
        },
    },
}
