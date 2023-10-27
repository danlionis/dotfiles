return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        opts = {
            -- transparent_background = true
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end
    }
    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {
    --         style = "night",
    --         transparent = true,
    --     },
    --     config = function(_, opts)
    --         require("tokyonight").setup(opts)
    --         vim.cmd.colorscheme("tokyonight")
    --     end
    -- },
    -- {
    --     'ayu-theme/ayu-vim',
    --     lazy = true
    -- },
}
