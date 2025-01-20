return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")

        -- enable mason and configure icons
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_lspconfig.setup({
            -- list of servers for mason to install
            ensure_installed = {
                'lua_ls',
                'rust_analyzer',
                'clangd',
                'jsonls',
                'html',
                'cmake',
                'pyright',
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = true, -- not the same as ensure_installed
        })

        -- debugger, linter, formatter, etc.
        mason_tool_installer.setup({
            ensure_installed = {
                'black',
                'debugpy',
                "codelldb",
                "cpptools",
                'mypy',
                'pylint',
                'isort',
            }
        })
    end,
}
