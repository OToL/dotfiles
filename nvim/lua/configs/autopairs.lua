local M = {}

M.setup = function()
    local autopairs = require("nvim-autopairs")

    autopairs.setup {
        check_ts = true, -- enable treesitter
        ts_config = {
            lua = { "string", "source" },
            javascript = { "string", "template_string", "guihua", "guihua_rust", "clap_input" },
            java = false,
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        fast_wrap = {
            map = "<M-e>",
            chars = { "{", "[", "(", '"', "'" },
            pattern = string.gsub([[ [%'%"%)%>%]%)%}%,%;] ]], "%s+", ""),
            offset = 0, -- Offset from pattern match
            end_key = "$",
            keys = "qwertyuiopzxcvbnmasdfghjkl",
            manual_position = true,
            check_comma = true,
            highlight = "Search",
            highlight_grey = "Normal",
        },
    }
end

return M
