-- Highlight characters when pressing f or F to make moves easier to identify
return {
    "jinh0/eyeliner.nvim",
    config = function()
        require("eyeliner").setup({
            -- highlight_on_key does not work for me
            -- it requires me to disable/enable eyeliner
            -- highlight_on_key = true,
        })

        -- vim.api.nvim_set_hl(0, 'EyelinerPrimary', { bold = true, underline = false })
        -- vim.api.nvim_set_hl(0, 'EyelinerSecondary', { underline = false })
    end
}
