-- Fast navigation by typing the first 2 characters + an extra one in case of ambiguity
return {
    dependencies = { "tpope/vim-repeat" },
    "ggandor/leap.nvim",
    config = function()
        local leap = require("leap")
        leap.opts.highlight_unlabeled_phase_one_targets = true
    end,
    keys = {
        -- leaping in current buffer
        { "<leader>bl", "<Plug>(leap)" },
        -- leaping in all visible buffer
        { "<leader>bL", "<Plug>(leap-anywhere)" },
    }
}
