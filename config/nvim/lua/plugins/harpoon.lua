local function harpoonSelectTable(keys)
    for i = 1, 9 do
        local entry = {
            ("<C-" .. i .. ">"),
            function() require("harpoon"):list():select(i) end,
            desc = "Harpoon " .. i,
            mode = "n"
        }

        table.insert(keys, entry)
    end

    return keys
end

local keys = {
    {
        "<leader>a",
        function() require("harpoon"):list():append() end,
        desc = "Harpoon Mark File",
        mode = "n"
    },
    {
        "<leader>ht",
        function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "[H]arpoon [T]oggle Menu",
        mode = "n"
    },
    {
        "<leader>hm",
        ":Telescope harpoon marks<CR>",
        desc = "[H]arpoon [M]arks",
        mode = "n"
    },
};


local allKeys = harpoonSelectTable(keys)

return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            'nvim-telescope/telescope.nvim',
        },
        keys = allKeys,
        config = function(_, opts)
            local harpoon = require("harpoon")
            harpoon:setup(opts)
            require("telescope").load_extension("harpoon")
        end
    }

}
