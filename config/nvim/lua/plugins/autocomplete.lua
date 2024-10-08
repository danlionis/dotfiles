return {
    { -- Autocompletion
        'hrsh7th/nvim-cmp',
        event = "InsertEnter",
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip'
        },
        opts = function()
            local cmp = require("cmp")
            return {
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    -- ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    -- ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    -- ["<TAB>"] = cmp.mapping.select_next_item(),
                    -- ["<S-TAB>"] = cmp.mapping.select_prev_item(),
                    -- ["<C-e>"] = cmp.mapping.abort(),
                    ["<TAB>"] = cmp.mapping.confirm({ select = true }),  -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<C-CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "crates" },
                    { name = "codeium" },
                    { name = "neorg" },
                    { name = "vim-dadbod-completion" },
                }),
                -- formatting = {
                --     format = function(_, item)
                --         local icons = require("lazyvim.config").icons.kinds
                --         if icons[item.kind] then
                --             item.kind = icons[item.kind] .. item.kind
                --         end
                --         return item
                --     end,
                -- },
                experimental = {
                    ghost_text = {
                        hl_group = "LspCodeLens",
                    },
                },
            }
        end,

    },
}
