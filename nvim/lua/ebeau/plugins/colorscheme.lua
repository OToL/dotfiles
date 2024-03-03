return {
    "catppuccin/nvim",
    -- make sure to load this before all the other start plugins
    -- default plugin priority is 50
    priority = 1000,
    config = function()
        vim.cmd([[colorscheme catppuccin]])
    end,
}

-- other colorschemes ...
--  "bluz71/vim-nightfly-guicolors",
