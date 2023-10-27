return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "jay-babu/mason-nvim-dap.nvim",
        },
        keys = {
            {
                "<leader>b",
                function() require("dap").toggle_breakpoint() end,
                desc =
                "[B]reakpoint [T]oggle"
            },
            {
                "<leader>B",
                function() require("dap").set_breakpoint(vim.fn.input("[Condition] > ")) end,
                desc =
                "[B]reakpoint [T]oggle Conditional"
            },
            {
                "<leader>dr",
                function() require("dap").repl.toggle() end,
                desc =
                "[D]rebugger [R]EPL"
            },
            {
                "<leader>dq",
                function() require("dap").close() end,
                desc =
                "[D]rebugger [Q]uit"
            },
            {
                "<F5>",
                function() require("dap").continue() end,
                desc =
                "Debugger Continue"
            },
            {
                "<F10>",
                function() require("dap").step_over() end,
                desc =
                "Debugger Step Over"
            },
            {
                "<F11>",
                function() require("dap").step_into() end,
                desc =
                "Debugger Step Into"
            },
            {
                "<F12>",
                function() require("dap").step_out() end,
                desc =
                "Debugger Step Out"
            },
        },
        config = function(_, opts)
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            vim.fn.sign_define("DapBreakpoint",
                { text = "🔴", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
            vim.fn.sign_define("DapBreakpointCondition",
                {
                    text = "🟠",
                    texthl = "DapBreakpointCondition",
                    linehl = "DapBreakpointCondition",
                    numhl = "DapBreakpointCondition"
                })
            -- vim.fn.sign_define("DapBreakpointCondition", { text = "" })
        end
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        lazy = true,
        config = true
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        keys = {
            { "<leader>du", function() require("dapui").toggle() end, { desc = "[D]rebugger [U]I" } },
        },
        -- dependencies = { "mfussenegger/nvim-dap" },
        config = function(_, _)
            require("dapui").setup()
        end
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        lazy = true,
        -- setup = true
        opts = {
            enure_installed = { "python", "codelldb", "gopls" },
            -- handlers = {}
            handlers = {
                function(config)
                    require("mason-nvim-dap").default_setup(config)
                end,

                -- c = function(config)
                --     config.configurations = {
                --         {
                --             name = 'C: Launch',
                --             type = 'codelldb',
                --             request = 'launch',
                --             program = function()
                --                 return vim.fn.input('Path to executable: ', vim.fn.getcwd(), 'file')
                --             end,
                --             cwd = '${workspaceFolder}',
                --             stopOnEntry = false,
                --             args = {},
                --         },
                --     }
                -- end
            }
        },
        config = true,
    }
}
