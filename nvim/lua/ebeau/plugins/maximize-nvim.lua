return {
    'declancm/maximize.nvim',
    config = function()
        require('maximize').setup(
            {
                plugins = {
                    dapui = { enable = true },
                }
            }
        )
    end,
    keys =
    {
        { "<leader>sm", "<cmd>lua require('maximize').toggle()<CR>", desc = "Maximize/minimize a split" },
    },
}
