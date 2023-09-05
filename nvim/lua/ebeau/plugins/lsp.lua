-- plugin displaying lsp parsing progress at the bottom write of the screen
local fidget_status_ok, fidget = pcall(require, 'fidget')
if not fidget_status_ok then
    return
end

local lspkind_ok, lspkind = pcall(require, "lspkind")
if not lspkind_ok then
    return
end

local luasnip_ok, _ = pcall(require, "luasnip")
if not luasnip_ok then
    return
end

-- completion plugin
local cmp_status_ok, cmp = pcall(require, 'cmp')
if not cmp_status_ok then
    return
end

-- lua snippets
local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
    return
end

-- plugin taking care of boiler-plate lsp/cmp/mason/... setup
local lsp_status_ok, lsp = pcall(require, "lsp-zero") -- display overloads
if not lsp_status_ok then
    return
end

fidget.setup()

-- load vs-code like snippets from plugins (e.g. friendly-snippets)
require("luasnip/loaders/from_vscode").lazy_load()

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
    ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    -- display all possible completion without typing anything
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<M-w>"] = cmp.mapping {
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
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
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
    suggest_lsp_servers = true,
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
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
    },
    -- configure lspkind for vs-code like pictograms in completion menu
    formatting = {
      format = lspkind.cmp_format({
            maxwidth = 50,       -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        }),
    },
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

local signs = { Error = "✘", Warn = " ", Hint = "⚑", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

lsp.on_attach(function(client, bufnr)
    local opts = { noremap = true, silent = true }

    if client.name == "eslint" then
        vim.cmd.LspStop('eslint')
        return
    end

    lsp_highlight_document(client)

    -- navigation
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "Gd", "<cmd>lua require('telescope.builtin').lsp_definitions({jump_type='vsplit'})<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gp", "<cmd>Lspsaga peek_definition<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k><C-o>', "<cmd>ClangdSwitchSourceHeader<CR>", opts)

    -- actions
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
    --vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    --vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    --vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<csd>Lspsaga hover_doc<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rs", "<cmd>LspRestart<CR>", opts)

    -- diagnostics
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>d", '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>D", '<cmd>Telescope diagnostics bufnr=0<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>fl", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

    -- symbols search
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>bs", "<cmd>lua require('telescope.builtin').lsp_document_symbols({symbols={'class', 'struct', 'function'}})<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ss", "<cmd>lua require('telescope.builtin').lsp_workspace_symbols({symbols={'class', 'struct', 'function'}})<CR>", opts)

    -- vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
    vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format{async=true}' ]])
    vim.cmd([[ command! FormatRange execute 'lua vim.lsp.buf.format(async=true)' ]])
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})
