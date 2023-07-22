local fidget_status_ok, fidget = pcall(require, 'fidget')
if not fidget_status_ok then
    return
end

local cmp_status_ok, cmp = pcall(require, 'cmp')
if not cmp_status_ok then
    return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
    return
end

local lsp_status_ok, lsp = pcall(require, "lsp-zero") -- display overloads
if not lsp_status_ok then
    return
end

local navigator_ok, navigator = pcall(require, 'navigator')
local guihua_maps_status_ok, guihua_maps = pcall(require, 'guihua.maps')
local lsp_signature_ok, lsp_signature = pcall(require, "lsp_signature")

fidget.setup()

-- help tabbing through snip parameters work better
local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

local cmp_mappings = lsp.defaults.cmp_mappings({
    -- scroll up/down completion suggestions
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    -- scroll up/down completion preview
    ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs( -1), { "i", "c" }),
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    -- display all possible completion without typing anything
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-c>"] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
    },
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm { select = true },
    -- "Super Tab": When a snippet has been selected, TAB and S-TAB are used to cycle parameters
    ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expandable() then
            luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        elseif check_backspace() then
            fallback()
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable( -1) then
            luasnip.jump( -1)
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
})

lsp.preset("recommended")

lsp.ensure_installed({
    'lua_ls',
    'rust_analyzer',
    'clangd',
})

-- Fix Undefined global 'vim'
lsp.configure('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

lsp.configure('clangd', {
    cmd =
    {
        "clangd",
        "--header-insertion=never",
        "--background-index",
        "--cross-file-rename",
        "--completion-style=detailed", -- do not collapse overloads in one entry
        "--suggest-missing-includes"
    }
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    manage_nvim_cmp = true,
    set_lsp_keymaps = false,
    sign_icons = {
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = ''
    }
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
    sources = {
        --{ name = 'nvim_lsp_signature_help' }, -- display overloads
        { name = 'nvim_lsp' },
        { name = 'vsnip' }
    }
})

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

if not navigator_ok then
    lsp.on_attach(function(client, bufnr)
        local opts = { noremap = true, silent = true }

        if client.name == "eslint" then
            vim.cmd.LspStop('eslint')
            return
        end

        lsp_highlight_document(client)

        vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "Gd", "<cmd>lua require('telescope.builtin').lsp_definitions({jump_type='vsplit'})<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()', opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>bs", "<cmd>lua require('telescope.builtin').lsp_document_symbols({symbols={'class', 'struct', 'function'}})<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ss", "<cmd>lua require('telescope.builtin').lsp_workspace_symbols({symbols={'class', 'struct', 'function'}})<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>fl", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
        --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
        --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
        --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k><C-o>', "<cmd>ClangdSwitchSourceHeader<CR>", opts)
        -- vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
        vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format{async=true}' ]])
        vim.cmd([[ command! FormatRange execute 'lua vim.lsp.buf.range_formatting()' ]])
    end)
end

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})

vim.cmd([[hi default GuihuaListSelHl guifg=#e0d8f4 guibg=#404254]])

if navigator_ok and guihua_maps_status_ok and lsp_signature_ok then
    vim.cmd("autocmd FileType guihua lua require('cmp').setup.buffer { enabled = false }")
    vim.cmd("autocmd FileType guihua_rust lua require('cmp').setup.buffer { enabled = false }")

    navigator.setup({
        --transparency = 90,
        default_mapping = false,
        mason = true,
        lsp = {
            format_on_save = false,
            code_action = {enable = false},
            code_lens_action = {enable = false}
        },
        on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true }

            if client.name == "eslint" then
                vim.cmd.LspStop('eslint')
                return
            end

            lsp_highlight_document(client)

            vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>bs", "<cmd>lua require('navigator.symbols').document_symbols()<CR>", opts)
            -- I use telescope because I did not manage to make fzy works with guihua (UI lib used by navigator.lua) and fuzzy search in the workspace is very slow as a result
            -- I m not using symbols filtering because it produces incomplete search result
            vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ss", "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>", opts)
            --vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ss", "<cmd>lua require('navigator.workspace').workspace_symbol_live()<CR>", opts)
            --vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>bs", "<cmd>lua require('telescope.builtin').lsp_document_symbols({symbols={'class', 'struct', 'function'}})<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua require('navigator.definition').definition()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "Gd", "<cmd>lua require('telescope.builtin').lsp_definitions({jump_type='vsplit'})<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "gp", "<cmd>lua require('navigator.definition').definition_preview()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua require('navigator.reference').async_ref()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", "<cmd>lua require('navigator.diagnostics').show_diagnostics()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "gL", "<cmd>lua require('navigator.diagnostics').show_buf_diagnostics()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "[r", "<cmd>lua require('navigator.treesitter').goto_previous_usage()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "]r", "<cmd>lua require('navigator.treesitter').goto_next_usage()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua require('navigator.codeAction').code_action()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "v", "<leader>ca", "<cmd>lua require('navigator.codeAction').range_code_action()<CR>", opts)
            --vim.api.nvim_buf_set_keymap(bufnr, "n", "<M-k>", "<cmd>lua require('lsp_signature').toggle_float_win()<CR>", opts)
            --vim.api.nvim_buf_set_keymap(bufnr, "i", "<M-k>", "<cmd>lua require('lsp_signature').toggle_float_win()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>k", "<cmd>lua require('navigator.dochighlight').hi_symbol()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "<F2>", "<cmd>lua require('navigator.rename').rename()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k><C-o>', "<cmd>ClangdSwitchSourceHeader<CR>", opts)

            vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format{async=true}' ]])
            vim.cmd([[ command! FormatRange execute 'lua vim.lsp.buf.range_formatting()' ]])
        end,
    })

    guihua_maps.setup({
        maps = {
            pageup = "<C-u>",
            pagedown = "<C-d>",
            jump_to_list = '<C-w>k',
            jump_to_preview = '<C-w>j',
            next = "<C-j>",
            prev = "<C-k>"
        }
    })

    lsp_signature.setup({
        hint_enable = false,
        handler_opts = { border = "single" },
        max_width = 80,
        timer_interval = 100,
        select_signature_key = "<M-n>"
        --toggle_key = "<M-k>"
    })

end
