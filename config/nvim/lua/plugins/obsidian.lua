return {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    event = {
        -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        -- refer to `:h file-pattern` for more examples
        "BufReadPre "
            .. vim.fn.expand("~")
            .. "/Documents/notes/*.md",
        "BufNewFile " .. vim.fn.expand("~") .. "/Documents/notes/*.md",
        -- TODO: load when entering vault
    },
    dependencies = {
        -- Required.
        "nvim-lua/plenary.nvim",

        -- see below for full list of optional dependencies 👇
    },
    opts = {
        workspaces = {
            {
                name = "notes",
                path = "~/Documents/notes/",
            },
        },

        notes_subdir = "zettelkasten",
        new_notes_location = "notes_subdir",

        daily_notes = {
            -- Optional, if you keep daily notes in a separate directory.
            folder = "journal",
        },

        -- way then set 'mappings = {}'.
        mappings = {
            -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
            ["gf"] = {
                action = function()
                    return require("obsidian").util.gf_passthrough()
                end,
                opts = { noremap = false, expr = true, buffer = true },
            },
            ["<C-p>"] = {
                action = ":ObsidianQuickSwitch<cr>",
                opts = { buffer = true },
            },
            -- Toggle check-boxes.
            ["<leader>ch"] = {
                action = function()
                    return require("obsidian").util.toggle_checkbox()
                end,
                opts = { buffer = true },
            },
            -- Smart action depending on context, either follow link or toggle checkbox.
            ["<C-cr>"] = {
                action = ":ObsidianFollowLink<cr>",
                opts = { buffer = true },
            },
            ["<leader>on"] = {
                action = ":ObsidianNew<cr>",
                opts = { buffer = true },
            },
            ["<leader>ob"] = {
                action = ":ObsidianBacklinks<cr>",
                opts = { buffer = true },
            },
            ["<leader>ol"] = {
                action = ":ObsidianLinks<cr>",
                opts = { buffer = true },
            },
            ["<leader>or"] = {
                action = ":ObsidianRename<cr>",
                opts = { buffer = true },
            },
            ["<leader>od"] = {
                action = ":ObsidianToday<cr>",
                opts = { buffer = true },
            },
            ["<leader>ot"] = {
                action = ":ObsidianTemplate<cr>",
                opts = { buffer = true },
            },
            ["<leader>oo"] = {
                action = ":ObsidianOpen<cr>",
                opts = { buffer = true },
            },
        },

        -- Optional, customize how note IDs are generated given an optional title.
        ---@param title string|?
        ---@return string
        note_id_func = function(title)
            -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
            -- In this case a note with the title 'My new note' will be given an ID that looks
            -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
            local suffix = ""
            if title ~= nil then
                -- If title is given, transform it into valid file name.
                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            else
                -- If title is nil, just add 4 random uppercase letters to the suffix.
                for _ = 1, 4 do
                    suffix = suffix .. string.char(math.random(65, 90))
                end
            end
            return tostring(os.time()) .. "-" .. suffix
        end,

        -- Optional, customize how note file names are generated given the ID, target directory, and title.
        ---@param spec { id: string, dir: obsidian.Path, title: string|? }
        ---@return string|obsidian.Path The full path to the new note.
        note_path_func = function(spec)
            -- This is equivalent to the default behavior.
            local path = spec.dir / tostring(spec.id)
            return path:with_suffix(".md")
        end,

        -- Optional, customize how wiki links are formatted. You can set this to one of:
        --  * "use_alias_only", e.g. '[[Foo Bar]]'
        --  * "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
        --  * "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
        --  * "use_path_only", e.g. '[[foo-bar.md]]'
        -- Or you can set it to a function that takes a table of options and returns a string, like this:
        wiki_link_func = function(opts)
            return require("obsidian.util").wiki_link_id_prefix(opts)
        end,

        -- Optional, customize how markdown links are formatted.
        markdown_link_func = function(opts)
            return require("obsidian.util").markdown_link(opts)
        end,

        ---@param url string
        follow_url_func = function(url)
            vim.ui.open(url) -- need Neovim 0.10.0+
        end,

        picker = {
            name = "telescope.nvim",
            mappings = {
                -- Create a new note from your query.
                new = "<C-x>",
                -- Insert a link to the selected note.
                insert_link = "<C-l>",
            },
        },

        ui = {
            enable = false,
        },

        -- Optional, for templates (see below).
        templates = {
            folder = "templates",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
            -- A map for custom variables, the key should be the variable and the value a function
            substitutions = {},
        },
    },
    config = function(_, opts)
        -- FOLDING:
        -- Use <CR> to fold when in normal mode
        -- To see help about folds use `:help fold`
        vim.keymap.set("n", "<CR>", function()
            -- Get the current line number
            local line = vim.fn.line(".")
            -- Get the fold level of the current line
            local foldlevel = vim.fn.foldlevel(line)
            if foldlevel == 0 then
                vim.notify("No fold found", vim.log.levels.INFO)
            else
                vim.cmd("normal! za")
            end
        end, { desc = "[P]Toggle fold" })
        require("obsidian").setup(opts)
    end,
}
