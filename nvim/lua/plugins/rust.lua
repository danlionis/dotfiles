return {
    {
        "simrat39/rust-tools.nvim",
        ft = { "rust", "toml" },
        opts = {
            server = {
                on_attach = function(client, bufnr)
                    require("dap")
                    require("dapui")
                    -- require("plugins.lsp.keymaps").on_attach(client, bufnr)
                    -- require("plugins.lsp.format").on_attach(client, bufnr)
                    vim.keymap.set("n", "K", function()
                        require("rust-tools").hover_actions.hover_actions()
                    end, { buffer = bufnr })
                end,
                settings = {
                    ["rust-analyzer"] = {
                        procMacro = { enable = true },
                        cargo = { features = "all" }
                    }
                }
            },
            tools = {
                hover_actions = {
                    auto_focus = false
                }
            }
        },
        config = function(_, opts)
            local mason_registry = require("mason-registry")

            local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
            local codelldb_path = codelldb_root .. "adapter/codelldb"
            local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"

            opts.dap = {
                adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
            }

            require("rust-tools").setup(opts)
        end
    },
    {
        'saecki/crates.nvim',
        event = "BufRead Cargo.toml",
        tag = 'v0.3.0',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            null_ls = {
                enabled = true,
                name = "crates.nvim"
            }
        },
        config = function(_, opts)
            local crates = require("crates")
            crates.setup(opts)
            crates.show()
        end
    }
}
