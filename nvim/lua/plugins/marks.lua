return {
    "chentoast/marks.nvim",
    config = function()
        require("marks").setup({
            force_write_shada = true,
            mappings =
            {
                next = "]b",
                prev = "[b",
            }
        })
    end,
    keys = {
        { "<leader>sM", ':Telescope marks<cr>' },
    }
}
