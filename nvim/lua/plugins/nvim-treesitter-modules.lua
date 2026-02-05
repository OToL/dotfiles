return {
    'MeanderingProgrammer/treesitter-modules.nvim',
    dependencies =
    {
        'nvim-treesitter/nvim-treesitter'
    },
    opts = {
        ensure_installed = {
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
        auto_install = true,
        fold = {
            enable = true,
        },
        indent = {
            enable = true,
            disable = { "cpp", "c" }, -- Only disable for C/C++, keep Python enabled
        },
        highlight = {
            enable = true,
            -- setting this to true will run `:h syntax` and tree-sitter at the same time
            -- set this to `true` if you depend on 'syntax' being enabled
            -- using this option may slow down your editor, and duplicate highlights
            -- instead of `true` it can also be a list of languages
            additional_vim_regex_highlighting = false,
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
    },
}
