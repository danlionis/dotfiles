return {
    -- nil_ls = {},
    nixd = {},
    htmx = {
        filetypes = { "html", "templ" },
    },
    html = {
        filetypes = { "html", "templ" },
        settings = {
            html = {
                autoClosingTags = true,
                format = {
                    enable = false, -- use prettier, also messes with templ
                },
                hover = {
                    documentation = true,
                    references = true,
                },
            },
        },
    },
    templ = {},
    tailwindcss = {
        filetypes = { "templ", "html", "css", "javascript" },
        settings = {
            tailwindCSS = {
                includeLanguages = {
                    templ = "html",
                },
            },
        },
    },
    ltex = {
        settings = {
            ltex = {
                disabledRules = {
                    ["en-US"] = { "ARROWS" },
                },
            },
        },
    },
    clangd = {},
    pyright = {},
    ts_ls = {},
    texlab = {},
    gopls = {
        settings = {
            gopls = {
                completeUnimported = true,
                usePlaceholders = false,
                hints = {
                    compositeLiteralFields = true,
                    constantValues = true,
                    parameterNames = true,
                },
            },
        },
    },
    svelte = {},
    lua_ls = {
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT)
                    version = "LuaJIT",
                    -- -- Setup your lua path
                    -- path = runtime_path,
                    --[[
                                local runtime_path = vim.split(package.path, ';')
                                table.insert(runtime_path, 'lua/?.lua')
                                table.insert(runtime_path, 'lua/?/init.lua')
                                --]]
                },
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = { enable = false },
            },
        },
    },
}
