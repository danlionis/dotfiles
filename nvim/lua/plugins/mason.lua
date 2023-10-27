return {
    {
        'williamboman/mason.nvim',
        cmd    = "Mason",
        opts   = {
            -- PATH = "append",
        },
        lazy   = true,
        config = true
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "jose-elias-alvarez/null-ls.nvim",
        },
        opts = {
            ensure_installed = nil,
            automatic_installation = true
        }
    }
}
