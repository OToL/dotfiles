local utils = require("utils")
local vim_config_path = vim.call("stdpath", "config")

-- prevent space from moving the cursor forward
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- remap space as leader key
vim.g.maplocalleader = " "
vim.g.mapleader = " "

vim.keymap.set('n', "<leader>lc", "<cmd>e ~/.config<CR>", { desc = "[L]oad the [c]onfigurations root" })
vim.keymap.set('n', "<leader>ln", "<cmd>e " .. utils.joinPaths(vim_config_path, "lua") .. "<CR>")
vim.keymap.set('n', "<leader>lk", "<cmd>e " .. utils.joinPaths(vim_config_path, "lua", "keymappings.lua") .. "<CR>", { desc = "[L]oad [k]eymappings.lua" })
vim.keymap.set('n', "<leader>lo", "<cmd>e " .. utils.joinPaths(vim_config_path, "lua", "options.lua") .. "<CR>", { desc = "[L]oad [o]options.lua" })
vim.keymap.set('n', "<leader>lw", "<cmd>e ~/.config/wezterm/wezterm.lua<CR>", { desc = "[L]oad [w]ezterm config" })

-- more practical insert mode exit
vim.keymap.set('i', "jk", "<ESC>")
vim.keymap.set('t', "jk", "<C-\\><C-n>", { silent = false })

-- visual studio block move up/down
vim.keymap.set('v', "<M-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set('v', "<M-k>", ":m '<-2<CR>gv=gv")

-- keep the cursor at its current position after joing lines
vim.keymap.set('n', "J", "mzJ`z")

-- window operations
vim.keymap.set('n', "<C-h>", "<C-w>h")
vim.keymap.set('n', "<C-j>", "<C-w>j")
vim.keymap.set('n', "<C-k>", "<C-w>k")
vim.keymap.set('n', "<C-l>", "<C-w>l")
vim.keymap.set('n', "<C-up>", "3<c-w>+")
vim.keymap.set('n', "<C-down>", "3<c-w>-")
vim.keymap.set('n', "<C-left>", "3<c-w><")
vim.keymap.set('n', "<C-right>", "3<c-w>>")
vim.keymap.set("n", "<M-w>", ":close<CR>", { desc = "[S]plit kill" })
vim.keymap.set('n', "<M-f>", "<cmd>lua require('utils').close_floating_windows()<cr>", { desc = "Close all floating windows" })

-- insert mode cursor move
vim.keymap.set('i', "<C-h>", "<Left>")
vim.keymap.set('i', "<C-j>", "<Down>")
vim.keymap.set('i', "<C-k>", "<Up>")
vim.keymap.set('i', "<C-l>", "<Right>")

-- delete text without filling default register
vim.keymap.set('n', "x", '"_x')
vim.keymap.set('x', "<leader>p", '"_dP')
vim.keymap.set({ 'v', 'n' }, "<leader>d", '"_d')

-- increment/decrement
vim.keymap.set('n', '<leader>+', '<C-a>')
vim.keymap.set('n', '<leader>-', '<C-x>')

-- jumps and scrolling
vim.keymap.set('n', "n", "nzzzv")
vim.keymap.set('n', "N", "Nzzz")
vim.keymap.set('n', "<C-o>", "<C-o>zz")
vim.keymap.set('n', "<C-i>", "<C-i>zz")
vim.keymap.set('n', "*", "*zz", { noremap = false, silent = false })
vim.keymap.set('n', "#", "#zz", { noremap = false, silent = false })

vim.keymap.set('n', "]]", "]]zz")
vim.keymap.set('n', "[]", "[]zz")
vim.keymap.set('n', "][", "][zz")
vim.keymap.set('n', "<M-k>", "5<C-y>")
vim.keymap.set('n', "<M-j>", "5<C-e>")

-- location list is local to a buffer (e.g. search results in current file) as opposed to quick-fix which is cross buffer (e.g. project compilation errors)
-- quick-fix list (:copen, :cclose/ccl, etc.) navigation
vim.keymap.set("n", "<F4>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<S-F4>", "<cmd>cprev<CR>zz")
vim.keymap.set('n', '<leader>qo', ':copen<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>qc', ':cclose<CR>', { noremap = true, silent = true })
-- :cc jump to current entry in quick fix list
vim.keymap.set('n', "<leader>tq", "<cmd>lua require('utils').toggle_qf()<cr>", { desc = "Toggle quick-fix list" })
-- location list (:lopen, :lclose/lcl, etc.) navigation
vim.keymap.set("n", "<F3>", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<S-F3>", "<cmd>lprev<CR>zz")

vim.keymap.set('n', 'zO', "<cmd>lua require('ufo').openAllFolds()<CR>")
vim.keymap.set('n', 'zC', "<cmd>lua require('ufo').closeAllFolds()<CR>")
vim.keymap.set('n', 'zk', "<cmd>lua require('ufo').peekFoldedLinesUnderCursor()<CR>")

-- yank from cursor to the end of line
vim.keymap.set('n', "Y", "y$")

-- Cahnge 'o'/'O' to not enter insertion mode after adding line
vim.keymap.set('n', "o", "o<esc>")
vim.keymap.set('n', "O", "O<esc>")
vim.keymap.set('n', "<M-O>", "O")
vim.keymap.set('n', "<M-o>", "o")
vim.keymap.set('i', "<M-O>", "<C-o>O")
vim.keymap.set('i', "<M-o>", "<C-o>o")

-- Expand to the current file's directory path
vim.keymap.set('c', "<C-w>d", "getcmdtype() == ':' ? expand('%:p:h').'/' : '%%'", { expr = true, noremap = true })
-- Expand to the current file's full path
vim.keymap.set('c', "<C-w>p", "getcmdtype() == ':' ? expand('%:p') : ''", { expr = true, noremap = true })
-- Expand to the file name with extension
vim.keymap.set('c', "<C-w>n", "getcmdtype() == ':' ? expand('%:t') : ''", { expr = true, noremap = true })
-- Expand to the current file relative path (absolute when the file is not in the current workspace)
vim.keymap.set('c', "<C-w>r", "getcmdtype() == ':' ? expand('%:.') : ''", { expr = true, noremap = true })
-- Copy current buffer name to clipboard
vim.keymap.set('n', "<M-m>n", function()
    local file_name = vim.fn.expand('%:t')
    vim.fn.setreg("+", file_name)
    vim.fn.setreg("0", file_name)
end, { expr = true, noremap = true })
-- Copy current buffer full path to clipboard
vim.keymap.set('n', "<M-m>p", function()
    local full_path = vim.fn.expand('%:p')
    vim.fn.setreg("+", full_path)
    vim.fn.setreg("0", full_path)
end, { expr = true, noremap = true })
-- Copy current buffer workspace relative path to clipboard
vim.keymap.set('n', "<M-m>r", function()
    local rel_path = vim.fn.expand('%:.')
    vim.fn.setreg("+", rel_path)
    vim.fn.setreg("0", rel_path)
end, { expr = true, noremap = true })
-- Copy current buffer directory path to clipboard 
vim.keymap.set('n', "<M-m>d", function()
    local dir_path = vim.fn.expand('%:p:h')
    vim.fn.setreg("+", dir_path)
    vim.fn.setreg("0", dir_path)
end, { expr = true, noremap = true })

-- navigate buffers
vim.keymap.set('n', "<M-l>", ":bnext<CR>")
vim.keymap.set('n', "<M-h>", ":bprevious<CR>")

-- stay in visual mode while indenting
vim.keymap.set('v', "<", "<gv")
vim.keymap.set('v', ">", ">gv")

-- formatting
vim.keymap.set("n", "==", vim.lsp.buf.format, { noremap = true, silent = true })
vim.keymap.set({ 'x', 'v' }, "=", vim.lsp.buf.format, { noremap = true, silent = true })

-- buffer operations
vim.keymap.set('n', "<leader>bd", "<cmd>bd!<CR>", { desc = "[B]uffer [D]elete" })
vim.keymap.set('n', "<leader>bf", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "[B]uffer [F]uzzy find" })
vim.keymap.set('n', "<leader>bk", function()
    local current = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current then
            vim.api.nvim_buf_delete(buf, { force = false })
        end
    end
end, { desc = "[B]uffer [K]ill all others" })

-- Search
vim.keymap.set('n', "<leader>sf", "<cmd>lua require('telescope.builtin').find_files({no_ignore=true,hidden=true})<cr>", { desc = "[S]earch [F]ile" })
vim.keymap.set('n', "<leader>sb", "<cmd>lua require('telescope.builtin').buffers()<cr>", { desc = "[S]earch [B]uffer" })
vim.keymap.set('n', "<leader>so", "<cmd>Telescope oldfiles<cr>", { desc = "[S]earch [o]ld files" })
vim.keymap.set('n', "<leader>sr", "<cmd>Telescope registers<cr>", { desc = "[S]earch [R]egister" })
vim.keymap.set('n', "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "[S]earch [K]ey remapping" })
vim.keymap.set('n', "<leader>sc", "<cmd>Telescope commands<cr>", { desc = "[S]earch [C]ommand" })
vim.keymap.set('n', "<leader>sC", "<cmd>Telescope colorscheme<cr>", { desc = "[S]earch [C]olor scheme" })
vim.keymap.set('n', "<leader>sM", "<cmd>Telescope man_pages<cr>", { desc = "[S]earch [M]an page" })
-- vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "[S]earch string in current working directory as you type using [G]rep" })
vim.keymap.set("n", "<leader>sg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
vim.keymap.set('n', "<leader>sd", "<cmd>Telescope diagnostics<cr>", { desc = "[S]earch [D]iagnostics" })

-- Workspaces
vim.keymap.set('n', "<leader>wl", "<cmd>Telescope workspaces<CR>", { desc = "List available workspaces" })

-- Cpp man
vim.keymap.set("n", "<leader>cc", function() require('cppman').open_cppman_for(vim.fn.expand("<cword>")) end)
vim.keymap.set("n", "<leader>cm", function() require('cppman').input() end)

-- Quick fix

-- Bookmarks
-- m; Toggle mark on current line
-- '<character> : Go to mark with <character> name
-- dm- Remove mark on current line
vim.keymap.set("n", "dm<Space>", '<cmd>delmarks!<cr>')

-- Misc
vim.keymap.set('n', "<ESC>", "<cmd>noh<cr>", { desc = "Delete last search highlight" })
