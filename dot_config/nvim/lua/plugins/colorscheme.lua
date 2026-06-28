return {
    {
        "catppuccin/nvim",
        enabled = false,
        name = "catppuccin",
        opts = {
            -- transparent_background = true
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end
    },
    {
        'projekt0n/github-nvim-theme',
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            local specs = {}
            if vim.fn.hostname() == "work" then
                specs = {
                    all = {
                        bg0 = "#000000", -- darkest background (status line, float windows, etc)
                        bg1 = "#000000", -- main editor background
                        bg2 = "#000000", -- cursor line / folds
                        bg3 = "#000000", -- lighter shades
                        bg4 = "#000000",
                    }
                }
            end

            require('github-theme').setup({
                specs = specs,
            })

            vim.cmd('colorscheme github_dark_default')
        end,
    }
    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {
    --         style = "night",
    --         transparent = true,
    --     },
    --     config = function(_, opts)
    --         require("tokyonight").setup(opts)
    --         vim.cmd.colorscheme("tokyonight")
    --     end
    -- },
    -- {
    --     'ayu-theme/ayu-vim',
    --     lazy = true
    -- },
}
