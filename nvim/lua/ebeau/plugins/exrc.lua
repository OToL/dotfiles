-- Automatically load & execute a script when opening a workspace
return {
    "MunifTanjim/exrc.nvim",
    dependencies = {
        "MunifTanjim/exrc.nvim"
    },
    config = function()
        vim.o.exrc = false
        require("exrc").setup({
          files = {
            ".nvim.lua",
            ".nvimrc.lua",
            ".nvimrc",
            ".exrc.lua",
            ".exrc",
          },
        })
    end,
}
