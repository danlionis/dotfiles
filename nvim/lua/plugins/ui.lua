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
    -- noicer ui
    {
        "folke/noice.nvim",
        enabled = false,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        event = "VeryLazy",
        opts = {
            cmdline = {
                view = "cmdline_popup",
                format = {
                    cmdline = { icon = ">" },
                    search_down = { icon = "/" },
                    help = { icon = "?" },
                    -- lua = { icon = "lua:" },
                }
            },
            messages = {
                enabled = true,
            },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
            },
            -- popupmenu = { enabled = false },
            presets = {
                -- bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = true,
            },
        },
        -- stylua: ignore
        keys = {
            {
                "<S-Enter>",
                function() require("noice").redirect(vim.fn.getcmdline()) end,
                mode = "c",
                desc = "Redirect Cmdline"
            },
            { "<leader>snl", function() require("noice").cmd("last") end,    desc = "Noice Last Message" },
            { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
            { "<leader>sna", function() require("noice").cmd("all") end,     desc = "Noice All" },
            {
                "<c-f>",
                function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,
                silent = true,
                expr = true,
                desc = "Scroll forward"
            },
            {
                "<c-b>",
                function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end,
                silent = true,
                expr = true,
                desc = "Scroll backward"
            },
        },
    },

    -- better vim.notify
    {
        "rcarriga/nvim-notify",
        enabled = true,
        keys = {
            {
                "<leader>un",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Delete all Notifications",
            },
        },
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
            vim.notify = require("notify")
            require("notify").setup(opts)
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

    -- active indent guide and indent text objects
    {
        "echasnovski/mini.indentscope",
        version = false, -- wait till new 0.7.0 release to put it back on semver
        event = "BufReadPre",
        opts = {
            symbol = "│",
        },
        config = function(_, opts)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
            require("mini.indentscope").setup(opts)
        end,
    },
    {
        "ThePrimeagen/harpoon",
        dependencies = {
            "nvim-lua/plenary.nvim",
            'nvim-telescope/telescope.nvim',
        },
        keys = {
            {
                "<leader>a",
                function() require("harpoon.mark").add_file() end,
                desc = "Harpoon Mark File",
                mode = "n"
            },
            {
                "<leader>ht",
                function() require("harpoon.ui").toggle_quick_menu() end,
                desc = "[H]arpoon [T]oggle Menu",
                mode = "n"
            },
            {
                "<leader>hm",
                ":Telescope harpoon marks<CR>",
                desc = "[H]arpoon [M]arks",
                mode = "n"
            },
            {
                "<C-1>",
                function() require("harpoon.ui").nav_file(1) end,
                desc = "Harpoon 1",
                mode = "n"
            },
            {
                "<C-2>",
                function() require("harpoon.ui").nav_file(2) end,
                desc = "Harpoon 2",
                mode = "n"
            },
            {
                "<C-3>",
                function() require("harpoon.ui").nav_file(3) end,
                desc = "Harpoon 3",
                mode = "n"
            },
            {
                "<C-4>",
                function() require("harpoon.ui").nav_file(4) end,
                desc = "Harpoon 4",
                mode = "n"
            },
            {
                "<C-5>",
                function() require("harpoon.ui").nav_file(5) end,
                desc = "Harpoon 5",
                mode = "n"
            },
        },
        config = function(_, opts)
            local harpoon = require("harpoon")
            harpoon.setup(opts)
            require("telescope").load_extension("harpoon")
        end
    }

}
