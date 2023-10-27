return {
    {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("neorg").setup {
                load = {
                    ["core.summary"] = {},
                    ["core.defaults"] = {}, -- Loads default behaviour
                    ["core.concealer"] = {
                        config = {
                            dim_code_blocks = {
                                width = "content",
                                content_only = true,
                                conceal = true
                            },
                            folds = false,
                            icons = {
                                ordered = {
                                    -- icons = { "1.", "A", "a", "⑴", "Ⓐ", "ⓐ" }
                                    -- formatters = { "(%s)", "%s.", "%s.", "(%s)" },
                                    icons = { "1", "A", "a", "1", "A", "a" }
                                }
                            }
                        }
                    },                  -- Adds pretty icons to your documents
                    ["core.dirman"] = { -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/neorg/notes",
                            },
                        },
                    },
                    ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
                    ["core.completion"] = { config = { engine = "nvim-cmp", name = "neorg" } },
                    ["core.export"] = { config = { exoprt_dir = "./export" } },
                },
            }
        end,
    },
}
