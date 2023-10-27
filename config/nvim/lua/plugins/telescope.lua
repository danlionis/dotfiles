function telescope_builtin(builtin, opts)
    return function()
        require("telescope.builtin")[builtin](opts)
    end
end

return {
    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-dap.nvim',
            "nvim-telescope/telescope-symbols.nvim",
            -- Fuzzy Finder Algorithm which dependencies local dependencies to be built. Only load if `make` is available
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },
        },
        cmd = "Telescope",
        keys = {
            { '<C-p>',     telescope_builtin("git_files"),       desc = 'Search git files' },
            { '<leader>,', telescope_builtin("oldfiles"),        desc = '[?] Find recently opened files' },
            { '<leader>:', telescope_builtin("command_history"), desc = '[:] Command History' },
            {
                '<leader>/',
                function()
                    -- You can pass additional configuration to telescope to change theme, layout, etc.
                    telescope_builtin("current_buffer_fuzzy_find", require('telescope.themes').get_dropdown {
                        winblend = 10,
                        previewer = false,
                    })()
                end,
                desc = '[/] Fuzzily search in current buffer]'
            },
            {
                '<leader><space>',
                telescope_builtin("buffers"),
                desc =
                '[ ] Find existing buffers'
            },
            {
                '<leader>sf',
                telescope_builtin("find_files"),
                desc =
                '[S]earch [F]iles'
            },
            {
                '<leader>sh',
                telescope_builtin("help_tags"),
                desc =
                '[S]earch [H]elp'
            },
            {
                '<leader>sw',
                telescope_builtin("grep_string"),
                desc =
                '[S]earch [W]ord under cursor'
            },
            {
                '<leader>sg',
                telescope_builtin("live_grep"),
                desc =
                '[S]earch by [G]rep'
            },
            {
                '<leader>sd',
                telescope_builtin("diagnostics"),
                desc =
                '[S]earch [D]iagnostiscs'
            },
            {
                '<leader>sk',
                telescope_builtin("keymaps"),
                desc =
                '[S]earch [K]eymaps'
            },
            {
                '<leader>sb',
                function()
                    telescope_builtin("builtin",
                        require('telescope.themes').get_dropdown({ previewer = false }))()
                end,
                desc =
                '[S]earch [B]uiltin'
            },
            {
                '<leader>sc',
                -- function()
                --     telescope_builtin("commands",
                --         require('telescope.themes').get_ivy({ previewer = false }))()
                -- end,
                telescope_builtin("commands"),
                desc =
                '[S]earch [C]ommands'
            },
            {
                '<leader>gb',
                telescope_builtin("git_branches"),
                desc =
                '[G]it [B]ranches'
            },
            {
                '<leader>gc',
                telescope_builtin("git_commits"),
                desc =
                '[G]it [C]ommits'
            },
            -- {
            --     "<leader>ss",
            --     telescope_builtin("lsp_document_symbols", {
            --         symbols = {
            --             "Class",
            --             "Function",
            --             "Method",
            --             "Constructor",
            --             "Interface",
            --             "Module",
            --             "Struct",
            --             "Trait",
            --             "Field",
            --             "Enum",
            --             "Property",
            --         },
            --     }),
            --     desc = "[S]earch [S]ymbols",
            -- },
        },
        opts = {
            defaults = {
                -- prompt_prefix = " ",
                -- selection_caret = " ",
                mappings = {
                    i = {
                        ["<C-h>"] = function()
                            telescope_builtin("find_files", { hidden = true })()
                        end,
                    },
                },
            },
        },
        config = function(_, opts)
            require('telescope').setup(opts)

            -- Enable telescope fzf native, if installed
            pcall(require('telescope').load_extension, 'fzf')
            require('telescope').load_extension('dap')
        end,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        keys = {
            {
                '<leader>e',
                function() require("telescope").extensions.file_browser.file_browser() end,
                desc = 'Search git files'
            },
        },
        config = function(_, opts)
            require("telescope").load_extension("file_browser")
        end
    },
    {
        enabled = false,
        "LinArcX/telescope-command-palette.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        opts = {
            extensions = {
                command_palette = {
                    { "File",
                        { "entire selection (C-a)",  ':call feedkeys("GVgg")' },
                        { "save current file (C-s)", ':w' },
                        { "save all files (C-A-s)",  ':wa' },
                        { "quit (C-q)",              ':qa' },
                        { "file browser (C-i)",      ":lua require'telescope'.extensions.file_browser.file_browser()", 1 },
                        { "search word (A-w)",       ":lua require('telescope.builtin').live_grep()",                  1 },
                        { "git files (A-f)",         ":lua require('telescope.builtin').git_files()",                  1 },
                        { "files (C-f)",             ":lua require('telescope.builtin').find_files()",                 1 },
                    },
                    { "Help",
                        { "tips",            ":help tips" },
                        { "cheatsheet",      ":help index" },
                        { "tutorial",        ":help tutor" },
                        { "summary",         ":help summary" },
                        { "quick reference", ":help quickref" },
                        { "search help(F1)", ":lua require('telescope.builtin').help_tags()", 1 },
                    },
                    { "Vim",
                        { "reload vimrc",              ":source $MYVIMRC" },
                        { 'check health',              ":checkhealth" },
                        { "jumps (Alt-j)",             ":lua require('telescope.builtin').jumplist()" },
                        { "commands",                  ":lua require('telescope.builtin').commands()" },
                        { "command history",           ":lua require('telescope.builtin').command_history()" },
                        { "registers (A-e)",           ":lua require('telescope.builtin').registers()" },
                        { "colorshceme",               ":lua require('telescope.builtin').colorscheme()",    1 },
                        { "vim options",               ":lua require('telescope.builtin').vim_options()" },
                        { "keymaps",                   ":lua require('telescope.builtin').keymaps()" },
                        { "buffers",                   ":Telescope buffers" },
                        { "search history (C-h)",      ":lua require('telescope.builtin').search_history()" },
                        { "paste mode",                ':set paste!' },
                        { 'cursor line',               ':set cursorline!' },
                        { 'cursor column',             ':set cursorcolumn!' },
                        { "spell checker",             ':set spell!' },
                        { "relative number",           ':set relativenumber!' },
                        { "search highlighting (F12)", ':set hlsearch!' },
                    }
                }
            }
        },
        config = function(_, opts)
            require("telescope").setup(opts)
            require('telescope').load_extension('command_palette')
        end
    }
}
