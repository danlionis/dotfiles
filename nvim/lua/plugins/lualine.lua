local colors = {
    red = '#cdd6f4',
    grey = '#181825',
    black = '#1e1e2e',
    white = '#313244',
    light_green = '#6c7086',
    orange = '#fab387',
    green = '#a6e3a1',
    blue = '#80A7EA',
}

local theme = {
    normal = {
        a = { fg = colors.black, bg = colors.blue },
        b = { fg = colors.blue, bg = colors.white },
        c = { fg = colors.white, bg = colors.black },
        z = { fg = colors.white, bg = colors.black },
    },
    insert = { a = { fg = colors.black, bg = colors.orange } },
    visual = { a = { fg = colors.black, bg = colors.green } },
    replace = { a = { fg = colors.black, bg = colors.green } },
}

local bubbles_theme = {
    normal = {
        a = { fg = colors.black, bg = colors.violet },
        b = { fg = colors.white, bg = colors.grey },
        c = { fg = colors.black, bg = colors.black },
    },

    insert = { a = { fg = colors.black, bg = colors.blue } },
    visual = { a = { fg = colors.black, bg = colors.cyan } },
    replace = { a = { fg = colors.black, bg = colors.red } },

    inactive = {
        a = { fg = colors.white, bg = colors.black },
        b = { fg = colors.white, bg = colors.black },
        c = { fg = colors.black, bg = colors.black },
    },
}

-- local mode = { "mode", --[[ separator = { right = '', left = '' } ,]] right_padding = 2 }
local mode = { "mode", separator = { right = '', left = '' }, right_padding = 2 }

local space = {
    function()
        return " "
    end
}

return {
    {
        'nvim-lualine/lualine.nvim',
        event = "VeryLazy",
        opts = function()
            local function fg(name)
                return function()
                    ---@type {foreground?:number}?
                    local hl = vim.api.nvim_get_hl_by_name(name, true)
                    return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
                end
            end

            return {
                options = {
                    theme = "auto",
                    -- theme = theme,
                    -- icons_enabled = false,
                    globalstatus = true,
                    disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
                    -- component_separators = { left = '', right = '' },

                    component_separators = "|",
                    section_separators = { left = '', right = '' },
                    -- section_separators = { left = '', right = '' },

                },
                sections = {
                    lualine_a = {
                        mode
                    },
                    lualine_b = { "branch", "diff" },
                    lualine_c = {
                        {
                            "filetype",
                            icon_only = true,
                            separator = "",
                            padding = {
                                left = 1,
                                right = 0
                            }
                        },
                        { "filename",    path = 1, symbols = { modified = "*", readonly = "", unnamed = "" } },
                        -- stylua: ignore
                        { "diagnostics", },
                        {
                            require("nvim-navic").get_location, cond = require("nvim-navic").is_available
                        },
                        -- { "buffers" },
                    },
                    lualine_x = {
                        -- stylua: ignore
                        -- {
                        --     function() return require("noice").api.status.command.get() end,
                        --     cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
                        --     color = fg("Statement")
                        -- },
                        -- stylua: ignore
                        -- {
                        --     function() return require("noice").api.status.mode.get() end,
                        --     cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                        --     color = fg("Constant"),
                        -- },
                        {
                            require("lazy.status").updates,
                            cond = require("lazy.status").has_updates,
                            color = fg("Special")
                        },
                    },
                    lualine_y = {
                        { "progress", padding = { left = 1, right = 0 }, separator = " " },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = {
                        {
                            function()
                                return os.date("%R")
                            end,
                            separator = { right = '', left = '' },
                            left_padding = 2
                        }
                    },
                },
                extensions = {
                    "fugitive",
                }
            }
        end,
    },

    -- lsp symbol navigation for lualine
    {
        "SmiteshP/nvim-navic",
        event = "BufReadPost",
        opts = { separator = " ", highlight = true, depth_limit = 5 },
        depencendies = {
            "neovim/nvim-lspconfig"
        }
    },
} -- Fancier statusline
