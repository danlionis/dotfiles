return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPost",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        ---@type TSConfig
        opts = {
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
            context_commentstring = { enable = true, enable_autocmd = false },
            ensure_installed = {
                'c',
                'go',
                'lua',
                'python',
                'rust',
                'javascript',
                'typescript',
                'vimdoc',
                'fish',
                "bash",
                "html",
                "javascript",
                "json",
                "markdown",
                "markdown_inline",
                "query",
                "regex",
                "typescript",
                "vim",
                "yaml",
            },
            playground = {
                enable = true,
            }
        },
        textobjects = {
            select = {
                enable = true,

                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    -- You can optionally set descriptions to the mappings (used in the desc parameter of
                    -- nvim_buf_set_keymap) which plugins like which-key display
                    ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                    -- You can also use captures from other query groups like `locals.scm`
                    ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                },
                -- You can choose the select mode (default is charwise 'v')
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * method: eg 'v' or 'o'
                -- and should return the mode ('v', 'V', or '<c-v>') or a table
                -- mapping query_strings to modes.
                selection_modes = {
                    ['@parameter.outer'] = 'v', -- charwise
                    ['@function.outer'] = 'V',  -- linewise
                    ['@class.outer'] = '<c-v>', -- blockwise
                },
                -- If you set this to `true` (default is `false`) then any textobject is
                -- extended to include preceding or succeeding whitespace. Succeeding
                -- whitespace has priority in order to act similarly to eg the built-in
                -- `ap`.
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * selection_mode: eg 'v'
                -- and should return true of false
                include_surrounding_whitespace = true,
            },
        },

        ---@param opts TSConfig
        config = function(_, opts)
            -- if plugin.ensure_installed then
            --   require("lazyvim.util").deprecate("treesitter.ensure_installed", "treesitter.opts.ensure_installed")
            -- end
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    {
        "nvim-treesitter/playground",
        cmd = "TSPlaygroundToggle",
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "BufReadPost",
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
    }
}
