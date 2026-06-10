local M = {}

M.setup = function()
    local augend = require "dial.augend"

    local function concat(tt)
        local v = {}
        for _, t in ipairs(tt) do
            vim.list_extend(v, t)
        end
        return v
    end

    local basic = {
        augend.integer.alias.decimal_int,
        -- augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.integer.alias.binary,
        augend.decimal_fraction.new { signed = true },
        augend.date.new {
            pattern = "%Y/%m/%d",
            default_kind = "day",
            clamp = true,
            end_sensitive = true,
        },
        augend.constant.new {
            elements = { "true", "false" },
            word = true,
            cyclic = true,
        },
        augend.constant.new {
            elements = { "True", "False" },
            word = true,
            cyclic = true,
        },
        augend.constant.alias.ja_weekday,
        augend.constant.alias.ja_weekday_full,
        augend.hexcolor.new { case = "lower" },
        augend.semver.alias.semver,
    }

    require("dial.config").augends:register_group {
        default = basic,
    }

    require("dial.config").augends:on_filetype {
        markdown = concat {
            basic,
            { augend.misc.alias.markdown_header },
        },
    }

    vim.keymap.set("n", "<C-a>", function() require("dial.map").manipulate("increment", "normal") end)
    vim.keymap.set("n", "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end)
    vim.keymap.set("n", "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end)
    vim.keymap.set("n", "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end)
    vim.keymap.set("v", "<C-a>", function() require("dial.map").manipulate("increment", "visual") end)
    vim.keymap.set("v", "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end)
    vim.keymap.set("v", "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end)
    vim.keymap.set("v", "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end)

end

return M
