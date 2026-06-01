return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			local ts = require("nvim-treesitter")

			-- 1. Setup (main only uses this for custom install directories if needed)
			ts.setup({})

			-- 2. Emulate ensure_installed
			local ensure_installed = {
				"bash",
				"c",
				"fish",
				"go",
				"html",
				"javascript",
				"json",
				"latex",
				"lua",
				"markdown",
				"markdown_inline",
				"nix",
				"python",
				"query",
				"regex",
				"rust",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			}

			ts.install(ensure_installed)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "<filetype>" },
				callback = function()
					vim.treesitter.start()
				end,
			})
			-- -- 3. Enable Core Highlighting and Indentation via Autocommands
			-- vim.api.nvim_create_autocmd("FileType", {
			-- 	callback = function(args)
			-- 		local buf = args.buf
			-- 		-- Enable native Treesitter highlighting if a parser exists
			-- 		local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
			-- 		if lang and pcall(vim.treesitter.start, buf, lang) then
			-- 			-- Enable native Treesitter indentation
			-- 			vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			-- 		end
			-- 	end,
			-- })
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPost",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true

			-- Or, disable per filetype (add as you like)
			-- vim.g.no_python_maps = true
			-- vim.g.no_ruby_maps = true
			-- vim.g.no_rust_maps = true
			-- vim.g.no_go_maps = true
		end,
		config = function()
			-- configuration
			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					-- You can choose the select mode (default is charwise 'v')
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * method: eg 'v' or 'o'
					-- and should return the mode ('v', 'V', or '<c-v>') or a table
					-- mapping query_strings to modes.
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						-- ['@class.outer'] = '<c-v>', -- blockwise
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
					include_surrounding_whitespace = false,
				},
			})

			-- keymaps
			-- You can use the capture groups defined in `textobjects.scm`
			vim.keymap.set({ "x", "o" }, "af", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "if", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end)
			-- vim.keymap.set({ "x", "o" }, "ac", function()
			-- 	require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			-- end)
			-- vim.keymap.set({ "x", "o" }, "ic", function()
			-- 	require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			-- end)
			-- You can also use captures from other query groups like `locals.scm`
			vim.keymap.set({ "x", "o" }, "as", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
			end)
		end,
	},

	-- {
	-- 	"nvim-treesitter/nvim-treesitter-textobjects",
	-- 	branch = "main",
	-- 	dependencies = { "nvim-treesitter/nvim-treesitter" },
	-- 	config = function()
	-- 		local select = require("nvim-treesitter-textobjects.select")
	--
	-- 		-- Configure lookahead and selection modes
	-- 		vim.g.no_plugin_maps = true
	--
	-- 		-- Re-create textobject keymaps manually using the main branch API
	-- 		local maps = {
	-- 			["af"] = { query = "@function.outer", mode = "V" }, -- linewise preferred for outer
	-- 			["if"] = { query = "@function.inner", mode = "v" },
	-- 			["ac"] = { query = "@class.outer", mode = "<c-v>" }, -- blockwise
	-- 			["ic"] = { query = "@class.inner", mode = "v" },
	-- 			["as"] = { query = "@local.scope", mode = "v", query_group = "locals" },
	-- 		}
	--
	-- 		for map, config in pairs(maps) do
	-- 			vim.keymap.set({ "x", "o" }, map, function()
	-- 				select.select_textobject(config.query, config.query_group or "textobjects")
	-- 			end)
	-- 		end
	-- 	end,
	-- },
}
