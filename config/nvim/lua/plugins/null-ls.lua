return {
    {
        "nvimtools/none-ls.nvim",
        event = "BufReadPost",
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.diagnostics.mypy,
                    null_ls.builtins.diagnostics.ruff,
                    null_ls.builtins.formatting.beautysh,
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.markdownlint,
                    null_ls.builtins.formatting.nixpkgs_fmt,
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.formatting.rustywind,
                    null_ls.builtins.formatting.sql_formatter,
                    null_ls.builtins.hover.dictionary,
                }
            })
        end

    }
}
