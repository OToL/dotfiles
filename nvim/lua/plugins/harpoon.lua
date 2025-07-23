function HarpoonDeleteCurrentBuffer()
    local harpoon = require("harpoon")
    local harpoon_list = harpoon:list()
    local current_file_full = vim.fn.expand('%:p')                            -- Get absolute path
    local current_file_relative = vim.fn.fnamemodify(current_file_full, ':.') -- Get workspace-relative path

    -- Iterate through the Harpoon list to find the index of the current file
    for idx, item in ipairs(harpoon_list.items) do
        print("Checking:", item.value)
        if item.value == current_file_full or item.value == current_file_relative then
            harpoon_list:remove_at(idx) -- Remove the item at the found index
            break
        end
    end
end

-- File bookmarks
return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("harpoon").setup({
            settings = {
                save_on_toggle = true,
                sync_on_ui_close = true,
            }
        })
    end,
    -- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
    -- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
    keys = {
        { "<leader>ha", '<cmd>lua require("harpoon"):list():add()<cr>',                                    desc = "Add current file to Harpoon" },
        { "<leader>hd", '<cmd>lua HarpoonDeleteCurrentBuffer()<cr>',                                       desc = "Remove current file from Harpoon" },
        { "<leader>ht", '<cmd>lua require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())<cr>', desc = "Toggle Harpoon visibility" },
        { "<M-1>",      '<cmd>lua require("harpoon"):list():select(1)<cr>' },
        { "<M-2>",      '<cmd>lua require("harpoon"):list():select(2)<cr>' },
        { "<M-3>",      '<cmd>lua require("harpoon"):list():select(3)<cr>' },
        { "<M-4>",      '<cmd>lua require("harpoon"):list():select(4)<cr>' },
        { "<M-5>",      '<cmd>lua require("harpoon"):list():select(5)<cr>' },
    }
}
