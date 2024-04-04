return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap-python",
        "nvim-neotest/nvim-nio",
    },
    FocusDapBuffer = function(buffer_name)
        for _, win in ipairs(vim.fn.getwininfo()) do
            local bufnr = vim.fn.winbufnr(win.winid)
            local bufname = vim.fn.bufname(bufnr)
            if bufname ~= '' and bufname:find(buffer_name, 1, true) then
                vim.api.nvim_set_current_win(win.winid)
                return
            end
        end

        -- If the DAP UI Watches buffer is not found, you can open it
        -- vim.cmd('DapUIWatches')
        print("hello watches")
    end,
    config = function()
        local dap = require("dap")
        local dap_ui = require("dapui")
        local dap_ui_widgets = require("dap.ui.widgets")
        local dap_python = require("dap-python")
        local icons = require("ebeau.core.icons")
        local utils = require("ebeau.core.utils")

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
        dap_python.setup(utils.find_program_path('python', true))

        --[[
        dap.configurations = {
        python =
          {
            request = 'launch';
            name = "Launch file";
            program = "${file}";
            pythonPath = function()
              return '/usr/bin/python3'
            end;
          },
        go = {
          {
            type = "go", -- Which adapter to use
            name = "Debug", -- Human readable name
            request = "launch", -- Whether to "launch" or "attach" to program
            program = "${file}", -- The buffer you are focused on when running nvim-dap
          },
        },
        javascript = {
          {
            type = 'node2';
            name = 'Launch',
            request = 'launch';
            program = '${file}';
            cwd = vim.fn.getcwd();
            sourceMaps = true;
            protocol = 'inspector';
            console = 'integratedTerminal';
          },
          {
            type = 'node2';
            name = 'Attach',
            request = 'attach';
            program = '${file}';
            cwd = vim.fn.getcwd();
            sourceMaps = true;
            protocol = 'inspector'
            console = 'integratedTerminal';
          },
        } }
        ]]

        -- Debug session workflow
        vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, {})
        vim.keymap.set('n', '<F10>', dap.step_over, {})
        vim.keymap.set('n', '<F11>', dap.step_into, {})
        vim.keymap.set('n', '<S-F11>', dap.step_out, {})
        vim.keymap.set('n', '<F5>', dap.continue, {})
        vim.keymap.set('n', '<S-F5>', dap.terminate, {})
        vim.keymap.set('n', '<C-S-F5>', function()
            dap.terminate()
            dap.run_last()
        end)
        vim.keymap.set("n", "<Leader>dl", dap.run_last, {})
        vim.keymap.set("n", "<Leader>dB", dap.clear_breakpoints, {})
        -- nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
        -- nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>

        -- Auxiliary options
        vim.keymap.set({ 'n', 'v' }, "<Leader>dk", dap_ui_widgets.hover, {})
        vim.keymap.set({ 'n', 'v' }, "<Leader>dp", dap_ui_widgets.preview, {})

        -- DAP windows focus
        vim.keymap.set("n", "<Leader>dw", "<cmd> lua require('ebeau.plugins.nvim-dap').FocusDapBuffer('DAP Watches')<cr><cr>", {})
        vim.keymap.set("n", "<Leader>db", "<cmd> lua require('ebeau.plugins.nvim-dap').FocusDapBuffer('DAP Breakpoints')<cr><cr>", {})
        vim.keymap.set("n", "<Leader>dv", "<cmd> lua require('ebeau.plugins.nvim-dap').FocusDapBuffer('DAP Scopes')<cr><cr>", {})
        vim.keymap.set("n", "<Leader>ds", "<cmd> lua require('ebeau.plugins.nvim-dap').FocusDapBuffer('DAP Stacks')<cr><cr>", {})

        vim.fn.sign_define('DapBreakpoint', { text = icons.ui.Breakpoint, texthl = '', linehl = '', numhl = '' })
        vim.fn.sign_define('DapStopped', { text = icons.ui.StackPointer, texthl = '', linehl = '', numhl = '' })
    end,
}
