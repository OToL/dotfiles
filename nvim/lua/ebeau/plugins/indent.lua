return {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
        vim.g.indent_blankline_use_treesitter = true
        require("ibl").setup({
           indent = { char = "┊" },
        })
    end,
}

