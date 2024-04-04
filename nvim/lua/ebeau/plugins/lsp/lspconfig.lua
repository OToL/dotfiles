return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { 'j-hui/fidget.nvim', tag = 'legacy' },
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    require("fidget").setup()

    local function lsp_highlight_document(client)
        if client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_exec([[
                augroup lsp_document_highlight
                    autocmd! * <buffer>
                    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                augroup END
                ]],
                false)
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
            bind = true, -- This is mandatory, otherwise border config won't get registered.
            hint_enable = false, -- hide the hint appearing on top of the signature
            handler_opts = { border = "rounded" },
            toggle_key = "<C-s>", -- toggle signature on and off in insert mode
            toggle_key_flip_floatwin_setting = true, -- fix a bug where the floating window was re-opened after toggle_key was pressed to hide it
            -- transparency = 20,
        }, bufnr)

        -- navigation
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "Gd", "<cmd>lua require('telescope.builtin').lsp_definitions({jump_type='vsplit'})<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gp", "<cmd>Lspsaga peek_definition<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>', opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", "<cmd>lua require('lsp_signature').toggle_float_win()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', "gh", "<cmd>ClangdSwitchSourceHeader<CR>", opts)

        -- actions
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
        --vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        --vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        --vim.api.nvim_buf_set_keymap(bufnr, 'i', '<C-k>', '<cmd>lua force_signature_help()<CR>', opts)
        --vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rs", "<cmd>LspRestart<CR>", opts)

        -- diagnostics
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>d", '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>D", '<cmd>Telescope diagnostics bufnr=0<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>fl", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

        -- symbols search
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>bs", "<cmd>lua require('telescope.builtin').lsp_document_symbols({symbols={'class', 'constructor', 'operator', 'interface', 'struct', 'method', 'function'}})<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ss", "<cmd>lua require('telescope.builtin').lsp_workspace_symbols({symbols={'class', 'constructor', 'operator', 'interface', 'struct', 'function'}})<CR>", opts)


        -- vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
        vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format{async=true}' ]])
        vim.cmd([[ command! FormatRange execute 'lua vim.lsp.buf.format(async=true)' ]])
    end

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    lspconfig['clangd'].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd =
        {
            "/usr/local/bin/clangd",
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

    lspconfig["rust_analyzer"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure typescript server with plugin
    lspconfig["tsserver"].setup({
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

    vim.diagnostic.config({
        virtual_text = true,
    })
  end,
}
