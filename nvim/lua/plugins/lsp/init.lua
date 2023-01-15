---@param on_attach fun(client, buffer)
local on_attach = function(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

return {
    -- {
    --     'j-hui/fidget.nvim',
    --     config = true
    -- },
    { -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        event = "BufReadPre",
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            'mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- -- Useful status updates for LSP
            -- 'fidget.nvim',
        },
        opts = {
            servers = {
                clangd = {},
                pyright = {},
                tsserver = {},
                texlab = {},
                gopls = {},
                sumneko_lua = {
                    settings = {
                        Lua = {
                            runtime = {
                                -- Tell the language server which version of Lua you're using (most likely LuaJIT)
                                version = 'LuaJIT',
                                -- -- Setup your lua path
                                -- path = runtime_path,
                                --[[
                                local runtime_path = vim.split(package.path, ';')
                                table.insert(runtime_path, 'lua/?.lua')
                                table.insert(runtime_path, 'lua/?/init.lua')
                                --]]
                            },
                            diagnostics = {
                                globals = { 'vim' },
                            },
                            workspace = {
                                library = vim.api.nvim_get_runtime_file('', true),
                                checkThirdParty = false,
                            },
                            -- Do not send telemetry data containing a randomized but unique identifier
                            telemetry = { enable = false },
                        },
                    },
                },
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            procMacro = { enable = true },
                            cargo = { features = "all" }
                        }
                    }
                }
            },
            setup = {}
        },
        config = function(_, opts)
            -- setup formatting and keymaps
            on_attach(function(client, buffer)
                require("plugins.lsp.format").on_attach(client, buffer)
                require("plugins.lsp.keymaps").on_attach(client, buffer)
            end)

            vim.diagnostic.config(opts.diagnostics)

            local servers = opts.servers
            local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

            require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
            require("mason-lspconfig").setup_handlers({
                function(server)
                    local server_opts = servers[server] or {}
                    server_opts.capabilities = capabilities
                    if opts.setup[server] then
                        if opts.setup[server](server, server_opts) then
                            return
                        end
                    elseif opts.setup["*"] then
                        if opts.setup["*"](server, server_opts) then
                            return
                        end
                    end
                    require("lspconfig")[server].setup(server_opts)
                end,
            })
        end
    },

    {
        'williamboman/mason.nvim',
        cmd  = "Mason",
        opts = { ensure_installed = {} },
        -- config = function(_, opts)
        --     require("mason").setup(opts)
        -- Vkkk

    }
}