-- I tried to use built-in LSP bug ...
--   LSPRestart, etc. were hard to replicate
--   No ClangdSwitchSourceHeader 
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { 'j-hui/fidget.nvim',                   tag = 'legacy' },
        { "antosha417/nvim-lsp-file-operations", config = true },
        "williamboman/mason.nvim",
        "glepnir/lspsaga.nvim",
        "ray-x/lsp_signature.nvim",
    },
    config = function()

        local lspconfig = require("lspconfig")

        -- highlight usages of the entity located under the cursor
        local function lsp_highlight_document(client)
            if client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_exec2([[
                augroup lsp_document_highlight
                    autocmd! * <buffer>
                    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                augroup END
            ]],
            {})
            end
        end

        local on_attach = function(client, bufnr)

            local opts = { noremap = true, silent = true }

            if client.name == "eslint" then
                vim.cmd.LspStop('eslint')
                return
            end

            lsp_highlight_document(client)

            -- enable lsp signature
            -- require "lsp_signature".on_attach({ handler_opts = { border = "rounded" }}, bufnr)
            -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua require('lsp_signature').toggle_float_win() <CR>", opts)

            require "lsp_signature".on_attach({
                bind = true,
                hint_enable = false,
                handler_opts = { border = "rounded" },
                toggle_key = "<C-s>",
                toggle_key_flip_floatwin_setting = true,
            }, bufnr)

            -- actions
            vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "grr", "<cmd>Telescope lsp_references<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "gri", "<cmd>Telescope lsp_implementations<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "grd", "<cmd>Telescope lsp_definitions<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "grD", "<cmd>lua require('telescope.builtin').lsp_definitions({jump_type='vsplit'})<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "grp", "<cmd>Lspsaga peek_definition<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "grs", "<cmd>lua require('lsp_signature').toggle_float_win()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', "grh", "<cmd>ClangdSwitchSourceHeader<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "grn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "gra", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "grl", "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>", opts)

            -- diagnostic
            vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-w>d", '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-w>D", '<cmd>Telescope diagnostics bufnr=0<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)

            vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>bs", "<cmd>lua require('telescope.builtin').lsp_document_symbols({symbols={'class', 'constructor', 'operator', 'interface', 'struct', 'method', 'function'}})<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ss", "<cmd>lua require('telescope.builtin').lsp_workspace_symbols({symbols={'class', 'constructor', 'operator', 'interface', 'struct', 'method', 'function'}})<CR>", opts)

            -- vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
            vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format{async=true}' ]])
            vim.cmd([[ command! FormatRange execute 'lua vim.lsp.buf.format(async=true)' ]])
        end

        -- NOTE(ebeau): changed to vim.lsp.protocol because of a nvim-cmp bug inserting double paranthesis (https://www.reddit.com/r/neovim/comments/1gg7yvy/rustanalyzer_through_rustaceanvim_inserts_extra/?rdt=65228)
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local mason_registry = require('mason-registry')

        -- local clangd_package = mason_registry.get_package('clangd')
        -- local clangd_filename = clangd_package:get_receipt():get().links.bin['clangd']
        -- "/usr/local/bin/clangd",
        -- local clangd_path = ('%s/%s'):format(clangd_package:get_install_path(), clangd_filename or 'clangd')
        local clangd_path = "/usr/local/bin/clangd"

        lspconfig['clangd'].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd =
            {
                clangd_path,
                "--header-insertion=never",
                "--background-index",
                "--completion-style=detailed", -- do not collapse overloads in one entry
                -- obsolete options
                -- "--cross-file-rename",
                -- "--suggest-missing-includes"
            }
        })

        -- configure python server
        lspconfig["pyright"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure json server
        lspconfig["jsonls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure html server
        lspconfig["html"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure html server
        lspconfig["cmake"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["rust_analyzer"].setup({
            settings = {
                ["rust-analyzer"] = {
                    completion = {
                        addCallArgumentSnippets = true, -- Automatic insertion of function arguments.
                        addCallParenthesis = true,      -- Automatic insertion of parentheses.
                    }
                }
            },
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure typescript server with plugin
        lspconfig["ts_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = { -- custom settings for lua
                Lua = {
                    -- make the language server recognize "vim" global
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        -- make language server aware of runtime files
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })
    end,
}

