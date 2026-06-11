---@diagnostic disable: unused-function, unused-local
local M = {}

local function select_dap_configuration()
    local dap = require('dap')
    local configs = dap.configurations.rust or {}
    local options = {}

    for i, config in ipairs(configs) do
        table.insert(options, { i, config.name })
    end

    vim.ui.select(options, {
        prompt = 'Select DAP configuration',
        format_item = function(item)
            return item[2]
        end
    }, function(choice)
        if choice then
            dap.run(configs[choice[1]])
        end
    end)
end

M.setup = function()
    local dap = require("dap")
    local dap_ui = require("dapui")
    local dap_ui_widgets = require("dap.ui.widgets")
    local dap_python = require("dap-python")
    local icons = require("icons")
    local utils = require("utils")

    dap.set_log_level('INFO')
    dap.listeners.before.attach.dap_ui_config = function()
        dap_ui.open()
    end
    dap.listeners.before.launch.dap_ui_config = function()
        dap_ui.open()
    end
    dap.listeners.before.event_terminated.dap_ui_config = function()
        dap_ui.close()
    end
    dap.listeners.before.event_exited.dap_ui_config = function()
        dap_ui.close()
    end

    dap_ui.setup()

    local python_interpreter = "python3"
    if utils.get_platform_name() == "windows" then
        python_interpreter = "python"
    end

    local python_path = utils.find_program_path(python_interpreter, true)
    -- local python_path = "C:\\Program Files\\Python313\\python.exe"
    dap_python.setup(python_path)

    dap.adapters["lldb"] = {
        type = 'executable',
        command = '/usr/local/bin/lldb-vscode',
        -- command = '/Users/emmanuelbeau/.cargo/bin/rust-lldb',
        name = "lldb"
    }

    dap.adapters["cpptools"] = {
        type = 'executable',
        id = "cpptools",
        name = "cpptools",
        command = vim.fn.stdpath('data') .. '/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
        -- command = vim.fn.stdpath('data') .. '/mason/bin/OpenDebugAD7',
        args = {},
        attach = {
            pidProperty = "processId",
            pidSelect = "ask"
        },
    }

    dap.adapters["codelldb"] = {
        type = 'server',
        port = "${port}",
        -- command = '/Users/emmanuelbeau/.local/share/nvim/mason/bin/codelldb',
        executable = {
            command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
            -- command = '/opt/homebrew/Cellar/llvm/19.1.3/bin/lldb-dap',
            -- command = '/usr/local/bin/codelldb', -- Adjust the path if necessary
            args = { "--port", "${port}" },
        }
    }

    -- Debug session workflow
    vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, {})
    vim.keymap.set('n', '<C-F9>', "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", {})
    vim.keymap.set('n', '<C-S-F9>', "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", {})
    vim.keymap.set('n', '<F5>', dap.continue, {})
    vim.keymap.set('n', '<F10>', dap.step_over, {})
    vim.keymap.set('n', '<F11>', dap.step_into, {})

    vim.keymap.set('n', '<S-F11>', dap.step_out, {})
    vim.keymap.set('n', '<F23>', dap.step_out, {})

    vim.keymap.set('n', '<S-F5>', dap.terminate, {})
    vim.keymap.set('n', '<F17>', dap.terminate, {})

    vim.keymap.set('n', '<F53>', function()
        dap.terminate()
        dap.run_last()
    end)
    vim.keymap.set('n', '<M-F5>', function()
        dap.terminate()
        dap.run_last()
    end)
    vim.keymap.set("n", "<Leader>dB", dap.clear_breakpoints, {})

    -- Auxiliary options
    vim.keymap.set({ 'n', 'v' }, "<Leader>dk", dap_ui_widgets.hover, {})
    vim.keymap.set({ 'n', 'v' }, "<Leader>dp", dap_ui_widgets.preview, {})

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<leader>td', dap_ui.toggle, { desc = 'Debug: See last session result.' })

    vim.keymap.set('n', '<Leader>dc', '<Cmd>lua require("dap").select_config()<CR>', { noremap = true, silent = true })

    dap.listeners.after.event_initialized['dapui_config'] = dap_ui.open
    dap.listeners.before.event_terminated['dapui_config'] = dap_ui.close
    dap.listeners.before.event_exited['dapui_config'] = dap_ui.close

    vim.fn.sign_define('DapBreakpoint', { text = icons.ui.Breakpoint, texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = icons.ui.StackPointer, texthl = '', linehl = '', numhl = '' })
end

return M
