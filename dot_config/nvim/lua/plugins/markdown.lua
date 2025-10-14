return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
            latex = { enabled = true },
            win_options = {
                conceallevel = { rendered = 2 },
            },
            pipe_table = {
                enabled = false,
            },
            file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "bullets-vim/bullets.vim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
}
