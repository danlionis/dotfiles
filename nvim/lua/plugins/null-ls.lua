return {
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = "BufReadPost",
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.beautysh,
                    null_ls.builtins.formatting.nixpkgs_fmt,
                    null_ls.builtins.diagnostics.mypy,
                    null_ls.builtins.diagnostics.ruff,
                    -- null_ls.builtins.completion.spell,
                    null_ls.builtins.hover.dictionary,
                }
            })
        end

    }
}
