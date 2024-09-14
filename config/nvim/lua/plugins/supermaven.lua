return {
    "supermaven-inc/supermaven-nvim",
    opts = {
        keymaps = {
            accept_suggestion = "<C-a>",
        },
    },
    lazy = false,
    keys = {
        { "<leader>smt", "<cmd>SupermavenToggle<cr>", desc = "[S]uper[M]aven [T]oggle" },
    },
    config = function(_, opts)
        require("supermaven-nvim").setup(opts)
    end,
}
