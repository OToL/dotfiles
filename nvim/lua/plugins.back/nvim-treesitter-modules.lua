return {
    "MeanderingProgrammer/treesitter-modules.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter"
    },
    opts = {
        -- enable syntax highlighting
        highlight = {
            enable = true,
        },
        auto_install = true,
        -- enable indentation
        indent = {
            enable = true,
            disable = { "cpp", "c" },     -- Only disable for C/C++, keep Python enabled
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
    }
}
