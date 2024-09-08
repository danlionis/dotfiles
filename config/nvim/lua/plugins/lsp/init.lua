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
    {
        'j-hui/fidget.nvim',
        lazy = true,
        config = true,
        tag = "legacy",
    },
    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        -- event = "BufReadPre",
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- -- Useful status updates for LSP
            'fidget.nvim',
        },
        opts = {
            servers = require("plugins.lsp.servers"),
            setup = {}
        },
        config = function(_, opts)
            require("plugins.lsp.keymaps").setup()
            on_attach(function(client, buffer)
                if client.server_capabilities.inlayHitProvider then
                    vim.lsp.inlay_hint.enable(buffer, true)
                end
            end)

            vim.diagnostic.config(opts.diagnostics)

            local servers = opts.servers
            local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())


            -- TODO: make this and mason-lspconfig nicer

            for server, server_opts in pairs(servers) do
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
                pcall(require("lspconfig")[server].setup, server_opts)
            end


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
}
