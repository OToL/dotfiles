return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    lazy = false,
    build = ':TSUpdate'
}
