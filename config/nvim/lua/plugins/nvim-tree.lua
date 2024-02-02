return {
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<C-n>", ":NvimTreeFindFileToggle<CR>" }
        },
        config = function()
            require("nvim-tree").setup {}
        end,
    }
}
