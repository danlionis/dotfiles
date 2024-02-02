return {
    {
        "ap/vim-css-color"
    },
    {
        "nvim-tree/nvim-web-devicons",
        event = "VeryLazy",
    },
    {
        'numToStr/Comment.nvim',
        event = "BufReadPost",
        config = true
    },
    -- better vim.notify
    {
        "rcarriga/nvim-notify",
        enabled = true,
        opts = {
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.50)
            end,
        },
        config = function(_, opts)
            require("notify").setup(opts)
            vim.notify = require("notify")
        end
    },

    -- better vim.ui
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },

    -- Add indentation guides even on blank lines
    {
        'lukas-reineke/indent-blankline.nvim',
        event = "BufReadPre",
        main = "ibl",
        opts = {
            indent = { char = '┊' },
            whitespace = {
                remove_blankline_trail = true,
            },
            scope = {
                enabled = false
            }
        }
    },

    {
        "folke/zen-mode.nvim",
        cmd  = { "ZenMode" },
        opts = {
            window = {
                options = {
                    number = false,
                    relativenumber = false
                }
            },
            plugins = {
                gitsigns = { enabled = true }
            }
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
}
