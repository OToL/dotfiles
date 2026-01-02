return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()

        -- configure treesitter
        require('nvim-treesitter').setup({
            -- enable syntax highlighting
            highlight = {
                enable = true,
            },
            auto_install = true,
            -- enable indentation
            indent =
                {
                    -- disabled because it was adding an extra indent when editing c++
                    -- enable = true
                    -- disable = { "python", "css", "cpp" }
                },
            -- enable autotagging (w/ nvim-ts-autotag plugin)
            autotag =
                {
                    enable = true,
                },
            autopairs = {
                enable = true,
            },
            -- ensure these language parsers are installed
            ensure_installed =
                {
                    "c",
                    "cpp",
                    "cmake",
                    "rust",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "bash",
                    "c_sharp",
                    "html",
                    "json",
                    "lua",
                    "yaml",
                    "javascript",
                    "typescript",
                    "vim",
                    "dockerfile",
                    "gitignore",
                },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<c-space>',
                    node_incremental = '<c-space>',
                    scope_incremental = '<c-s>',
                    node_decremental = '<bs>',
                },
            },
        })
    end,
}

