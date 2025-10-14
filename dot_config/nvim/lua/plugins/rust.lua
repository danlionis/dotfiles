return {
    -- {
    --     "simrat39/rust-tools.nvim",
    --     ft = { "rust", "toml" },
    --     opts = {
    --         server = {
    --             on_attach = function(client, bufnr)
    --                 require("dap")
    --                 require("dapui")
    --                 -- require("plugins.lsp.keymaps").on_attach(client, bufnr)
    --                 -- require("plugins.lsp.format").on_attach(client, bufnr)
    --                 vim.keymap.set("n", "K", function()
    --                     require("rust-tools").hover_actions.hover_actions()
    --                 end, { buffer = bufnr })
    --             end,
    --             settings = {
    --                 ["rust-analyzer"] = {
    --                     procMacro = { enable = true },
    --                     cargo = { features = "all" },
    --                 },
    --             },
    --         },
    --         tools = {
    --             hover_actions = {
    --                 auto_focus = false,
    --             },
    --         },
    --     },
    --     config = function(_, opts)
    --         require("rust-tools").setup(opts)
    --     end,
    -- },
    {
        "mrcjkb/rustaceanvim",
        version = "^6", -- Recommended
        lazy = false, -- This plugin is already lazy
        config = function()
            vim.g.rustaceanvim = {
                -- Plugin configuration
                tools = {},
                -- LSP configuration
                server = {
                    default_settings = {
                        -- rust-analyzer language server configuration
                        ["rust-analyzer"] = {
                            procMacro = { enable = true },
                            cargo = { features = "all" },
                        },
                    },
                },
                -- DAP configuration
                dap = {},
            }
        end,
    },
    {
        "saecki/crates.nvim",
        event = "BufRead Cargo.toml",
        tag = "v0.3.0",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            null_ls = {
                enabled = true,
                name = "crates.nvim",
            },
        },
        config = function(_, opts)
            local crates = require("crates")
            crates.setup(opts)
            crates.show()
        end,
    },
}
