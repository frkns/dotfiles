-- Debugging plugins

return {
    -- nvim-dap for Python debugging
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require('dap')
            dap.adapters.python = {
                type = 'executable',
                command = 'python3',
                args = { '-m', 'debugpy.adapter' },
            }
            dap.configurations.python = {
                {
                    type = 'python',
                    request = 'launch',
                    name = "Launch file",
                    program = "${file}",
                    pythonPath = function()
                        local venv_path = os.getenv('VIRTUAL_ENV')
                        if venv_path then
                            return venv_path .. '/bin/python'
                        else
                            return '/usr/bin/python3'
                        end
                    end,
                },
            }
        end,
    },

    -- nvim-dap-ui for better debugging interface
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()

            -- Auto-open/close UI
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Debug keymaps with <leader>d prefix
            vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end,
                { desc = 'Debug: Start/Continue' })
            vim.keymap.set('n', '<leader>dn', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
            vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
            vim.keymap.set('n', '<leader>do', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
            vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end,
                { desc = 'Debug: Toggle Breakpoint' })
            vim.keymap.set('n', '<leader>dB',
                function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
                { desc = 'Debug: Set Conditional Breakpoint' })
            vim.keymap.set('n', '<leader>dt', function() require('dap').terminate() end, { desc = 'Debug: Terminate' })
            vim.keymap.set('n', '<leader>du', function() require('dapui').toggle() end, { desc = 'Debug: Toggle UI' })
        end,
    },
}
