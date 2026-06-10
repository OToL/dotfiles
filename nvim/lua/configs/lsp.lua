local M = {}
local peek_win      = nil
local peek_location = nil
local peek_stack    = {}

local function close_peek()
    if peek_win and vim.api.nvim_win_is_valid(peek_win) then
        vim.api.nvim_win_close(peek_win, true)
    end
    peek_win = nil
end

local function open_peek(location)
    local uri   = location.uri or location.targetUri
    local range = location.range or location.targetSelectionRange
    local bufnr = vim.fn.bufadd(vim.uri_to_fname(uri))
    vim.fn.bufload(bufnr)

    local width  = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.6)
    peek_win      = vim.api.nvim_open_win(bufnr, true, {
        relative = 'editor',
        width    = width,
        height   = height,
        row      = math.floor((vim.o.lines - height) / 2),
        col      = math.floor((vim.o.columns - width) / 2),
        style    = 'minimal',
        border   = 'rounded',
    })
    peek_location = location
    vim.api.nvim_win_set_cursor(peek_win, { range.start.line + 1, range.start.character })

    -- q: close and clear entire history
    vim.keymap.set('n', 'q', function()
        close_peek()
        peek_stack    = {}
        peek_location = nil
    end, { buffer = bufnr, noremap = true, silent = true })

    -- M-w: go back to previous peek, or close if no history
    vim.keymap.set('n', '<M-w>', function()
        close_peek()
        if #peek_stack > 0 then
            open_peek(table.remove(peek_stack))
        else
            peek_location = nil
        end
    end, { buffer = bufnr, noremap = true, silent = true })
end

M.setup = function()

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
            local bufnr  = ev.buf
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if not client then return end

            if client.name == 'eslint' then
                client:stop(true)
                return
            end

            if client:supports_method('textDocument/completion') then
                vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
                vim.api.nvim_create_autocmd('InsertCharPre', {
                    buffer = bufnr,
                    callback = function()
                        if vim.v.char:match('[%w_]') then
                            vim.schedule(function() vim.lsp.completion.get() end)
                        end
                    end,
                })
            end

            -- document highlight on cursor hold
            if client.server_capabilities.documentHighlightProvider then
                vim.api.nvim_create_autocmd('CursorHold',  { buffer = bufnr, callback = vim.lsp.buf.document_highlight })
                vim.api.nvim_create_autocmd('CursorMoved', { buffer = bufnr, callback = vim.lsp.buf.clear_references })
            end

            -- clangd: switch between source and header
            if client.name == 'clangd' then
                vim.api.nvim_buf_create_user_command(bufnr, 'ClangdSwitchSourceHeader', function()
                    client:request('textDocument/switchSourceHeader', { uri = vim.uri_from_bufnr(0) }, function(err, result)
                        if err then
                            vim.notify('Error switching source/header: ' .. vim.inspect(err), vim.log.levels.ERROR)
                            return
                        end
                        if not result or result == '' then
                            vim.notify('No corresponding source/header file found', vim.log.levels.WARN)
                            return
                        end
                        vim.cmd.edit(vim.uri_to_fname(result))
                    end, bufnr)
                end, { desc = 'Switch between source and header file' })
            end

            require('lsp_signature').on_attach({
                bind                           = true,
                handler_opts                   = { border = 'rounded' },
                hint_enable                    = false,
                floating_window_above_cur_line = true,
                toggle_key                     = '<C-s>',
                toggle_key_flip_floatwin_setting = true,
            }, bufnr)

            local opts = { buffer = bufnr, noremap = true, silent = true }

            vim.keymap.set('n', 'K',    vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'grs',  vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', 'grn',  vim.lsp.buf.rename, opts)
            vim.keymap.set('n', 'gra',  vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'grl',  function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, opts)
            vim.keymap.set('n', 'grh',  '<cmd>ClangdSwitchSourceHeader<CR>', opts)

            -- navigate: telescope for multi-result, split variant
            vim.keymap.set('n', 'grr',  '<cmd>Telescope lsp_references<CR>', opts)
            vim.keymap.set('n', 'gri',  '<cmd>Telescope lsp_implementations<CR>', opts)
            vim.keymap.set('n', 'grd',  '<cmd>Telescope lsp_definitions<CR>', opts)
            vim.keymap.set('n', 'grD',  function() require('telescope.builtin').lsp_definitions({ jump_type = 'vsplit' }) end, opts)
            -- peek: open definition in a focused floating window, M-w navigates back
            vim.keymap.set('n', 'grp', function()
                local req_win = vim.api.nvim_get_current_win()
                local req_buf = vim.api.nvim_get_current_buf()
                local params  = vim.lsp.util.make_position_params(req_win, 'utf-8')

                vim.lsp.buf_request(req_buf, 'textDocument/definition', params, function(_, result)
                    if not result then return end
                    local location = vim.islist(result) and result[1] or result
                    if not location then return end

                    if peek_win and vim.api.nvim_win_is_valid(peek_win) and peek_location then
                        table.insert(peek_stack, peek_location)
                    end
                    close_peek()
                    open_peek(location)
                end)
            end, opts)

            vim.keymap.set('i', '<M-w>', '<C-e>', opts)
            vim.keymap.set('i', '<CR>', function()
                if vim.fn.pumvisible() == 1 then
                    return vim.api.nvim_replace_termcodes('<C-y>', true, false, true)
                end
                return vim.api.nvim_replace_termcodes('<CR>', true, false, true)
            end, { buffer = bufnr, noremap = true, silent = true, expr = true })
            vim.keymap.set('i', '<Tab>', function()
                if vim.snippet.active({ direction = 1 }) then
                    return vim.api.nvim_replace_termcodes('<Cmd>lua vim.snippet.jump(1)<CR>', true, false, true)
                elseif vim.fn.pumvisible() == 1 then
                    return vim.api.nvim_replace_termcodes('<C-n>', true, false, true)
                end
                return vim.api.nvim_replace_termcodes('<Tab>', true, false, true)
            end, { buffer = bufnr, noremap = true, silent = true, expr = true })
            vim.keymap.set('i', '<S-Tab>', function()
                if vim.snippet.active({ direction = -1 }) then
                    return vim.api.nvim_replace_termcodes('<Cmd>lua vim.snippet.jump(-1)<CR>', true, false, true)
                elseif vim.fn.pumvisible() == 1 then
                    return vim.api.nvim_replace_termcodes('<C-p>', true, false, true)
                end
                return vim.api.nvim_replace_termcodes('<S-Tab>', true, false, true)
            end, { buffer = bufnr, noremap = true, silent = true, expr = true })

            -- diagnostics
            vim.keymap.set('n', '<C-w>d', function() vim.diagnostic.open_float({ border = 'rounded' }) end, opts)
            vim.keymap.set('n', '<C-w>D', '<cmd>Telescope diagnostics bufnr=0<CR>', opts)
            vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = { border = 'rounded' } }) end, opts)
            vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count =  1, float = { border = 'rounded' } }) end, opts)

            -- symbols
            local symbols = { 'class', 'constructor', 'operator', 'interface', 'struct', 'method', 'function' }
            vim.keymap.set('n', '<leader>bs', function() require('telescope.builtin').lsp_document_symbols({ symbols = symbols }) end, opts)
            vim.keymap.set('n', '<leader>ss', function() require('telescope.builtin').lsp_workspace_symbols({ symbols = symbols }) end, opts)

            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
                vim.lsp.buf.format({ async = true })
            end, { desc = 'Format buffer' })
        end
    })

    vim.api.nvim_create_autocmd('CompleteDone', {
        callback = function()
            if vim.v.event.reason ~= 'accept' then return end
            local item     = vim.v.completed_item
            local lsp_item = vim.tbl_get(item, 'user_data', 'nvim', 'lsp', 'completion_item')
            if not lsp_item then return end
            -- Function=3, Method=2, Constructor=4
            local kind = lsp_item.kind
            if kind ~= 2 and kind ~= 3 and kind ~= 4 then return end
            -- skip if LSP already sent a snippet (e.g. clangd's func($1, $2))
            if lsp_item.insertTextFormat == 2 then return end
            -- skip if ( already present at cursor
            local col  = vim.fn.col('.')
            local line = vim.api.nvim_get_current_line()
            if line:sub(col, col) == '(' then return end
            vim.api.nvim_feedkeys('(', 'n', false)
        end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    vim.lsp.config('clangd', {
        cmd = {
            '/usr/local/bin/clangd',
            '--header-insertion=never',
            '--background-index',
            '--completion-style=detailed',
        },
        filetypes    = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
        root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac', '.git' },
        capabilities = capabilities,
    })

    vim.lsp.config('pyright', {
        cmd          = { 'pyright-langserver', '--stdio' },
        filetypes    = { 'python' },
        root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
        capabilities = capabilities,
    })

    vim.lsp.config('jsonls', {
        cmd          = { 'vscode-json-language-server', '--stdio' },
        filetypes    = { 'json', 'jsonc' },
        capabilities = capabilities,
    })

    vim.lsp.config('html', {
        cmd          = { 'vscode-html-language-server', '--stdio' },
        filetypes    = { 'html' },
        capabilities = capabilities,
    })

    vim.lsp.config('cmake', {
        cmd          = { 'cmake-language-server' },
        filetypes    = { 'cmake' },
        root_markers = { 'CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake' },
        capabilities = capabilities,
    })

    vim.lsp.config('rust_analyzer', {
        cmd          = { 'rust-analyzer' },
        filetypes    = { 'rust' },
        root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
        capabilities = capabilities,
        settings     = {
            ['rust-analyzer'] = {
                completion = {
                    addCallArgumentSnippets = true,
                    addCallParenthesis      = true,
                }
            }
        },
    })

    vim.lsp.config('ts_ls', {
        cmd          = { 'typescript-language-server', '--stdio' },
        filetypes    = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
        root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
        capabilities = capabilities,
    })

    vim.lsp.config('lua_ls', {
        cmd          = { 'lua-language-server' },
        filetypes    = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
        capabilities = capabilities,
        settings     = {
            Lua = {
                diagnostics = { globals = { 'vim' } },
                workspace   = {
                    library = {
                        [vim.fn.expand('$VIMRUNTIME/lua')]        = true,
                        [vim.fn.stdpath('config') .. '/lua']      = true,
                    },
                },
            },
        },
    })

    vim.lsp.enable({ 'clangd', 'pyright', 'jsonls', 'html', 'cmake', 'rust_analyzer', 'ts_ls', 'lua_ls' })

end

return M
