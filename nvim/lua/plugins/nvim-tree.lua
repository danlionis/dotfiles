return {
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<C-n>", ":NvimTreeToggle<CR>" }
        },
        config = function()
            require("nvim-tree").setup {}
        end,
    }
}
