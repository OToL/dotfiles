return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- same as require("bufferline").setup(opts)
    opts = {
        options = {
            separator_style = "slant",
            offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
            --separator_style = "thick", -- | "thick" | "thin" | { 'any', 'any' },

            close_command = "BufDel! %d",       -- can be a string | function, see "Mouse actions"
            right_mouse_command = "BufDel! %d", -- can be a string | function, see "Mouse actions"
        },
    },
}
