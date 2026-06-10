local M = {}

M.setup = function()
    require('maximize').setup(
        {
            plugins = {
                dapui = { enable = true },
            }
        }
    )
end

vim.keymap.set("n", "<leader>sm", "<cmd>lua require('maximize').toggle()<CR>", { desc = "Maximize/minimize a split" })

return M
