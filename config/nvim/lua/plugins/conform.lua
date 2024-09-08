return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            python = { "ruff_organize_imports", "ruff_format" },
            -- You can customize some of the format options for the filetype (:help conform.format)
            rust = { "rustfmt", lsp_format = "fallback" },
            -- Conform will run the first available formatter
            javascript = { "prettierd", "prettier", stop_after_first = true },

            nix = { "nixfmt" },

            templ = { "templ", "rustywind", lsp_format = "fallback" },

            sql = { "sql_formatter" },

            lua = { "stylua" },
        },
        formatters = {
            sql_formatter = {
                prepend_args = {
                    "-c",
                    ".sql-formatter.json", -- default in "sql-formatter@15.4.0, but not yet in nixpkgs"
                },
            },
        },
        format_on_save = {
            -- I recommend these options. See :help conform.format for details.
            lsp_format = "fallback",
            timeout_ms = 500,
        },
    },
    config = function(_, opts)
        require("conform").setup(opts)

        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function(args)
                require("conform").format({ bufnr = args.buf })
            end,
        })
    end,
}
