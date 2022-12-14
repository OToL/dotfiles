--require("tokyonight").setup({
--  -- use the night style
--  style = "night",
--  -- disable italic for functions
--  sidebars = { "qf", "vista_kind", "terminal", "packer" },
--  -- Change the "hint" color to the "orange" color, and make the "error" color bright red
--  on_colors = function(colors)
--    colors.comment = "#ABABAB"
--    --colors.error = "#ff0000"
--  end
--})
require('onedark').setup {
    style = 'darker',
    highlights = {
        ["@comment"] = {fg = "#ABABAB"},
    }
}

require('onedark').load()

