local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- change color for arrows in tree to light blue
vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

local function custom_on_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    --mappings = {
    --  list = {
    --    { key = "h", cb = tree_cb "close_node" },
    --    { key = "u", cb = tree_cb "dir_up" },
    --    { key = "<C-c>", cb = tree_cb "cd" },
    --  },
    --},

    -- custom mappings
    vim.keymap.set('n', '<C-r>', api.tree.change_root_to_node, opts('Up'))
    --vim.keymap.set('n', 'h', api.tree.close_node, opts('Close'))
    vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
end

nvim_tree.setup {
    on_attach = custom_on_attach,
    sync_root_with_cwd = true,
    update_focused_file = {
        enable = true,
        update_cwd = false,
    },
    view = {
        adaptive_size = true,
        width = 30,
        side = "left",
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
}
