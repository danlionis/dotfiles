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

            markdown = { "prettierd", "prettier", stop_after_first = true },

            json = { "prettierd", "prettier", stop_after_first = true },

            html = { "prettierd", "prettier", stop_after_first = true },

            vue = { "prettierd", "prettier", stop_after_first = true },

            css = { "prettierd", "prettier", stop_after_first = true },

            bash = { "shellcheck", "shfmt" },

            c = { "clang_format" },
        },
        formatters = {
            sql_formatter = {
                prepend_args = {
                    "-c",
                    ".sql-formatter.json", -- default in "sql-formatter@15.4.0, but not yet in nixpkgs"
                },
            },
        },
        format_on_save = function(bufnr)
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end
            -- I recommend these options. See :help conform.format for details.
            return { timeout_ms = 500, lsp_format = "fallback" }
        end,
    },
    config = function(_, opts)
        require("conform").setup(opts)

        vim.api.nvim_create_user_command("FormatDisable", function(args)
            if args.bang then
                -- FormatDisable! will disable formatting just for this buffer
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
        end, {
            desc = "Disable autoformat-on-save",
            bang = true,
        })
        vim.api.nvim_create_user_command("FormatEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, {
            desc = "Re-enable autoformat-on-save",
        })
    end,
}
