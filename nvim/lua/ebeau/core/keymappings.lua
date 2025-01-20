local utils = require("ebeau.core.utils")
local vim_config_path = vim.call("stdpath", "config")

-- prevent space from moving the cursor forward
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- remap space as leader key
vim.g.maplocalleader = " "
vim.g.mapleader = " "

-- lua config file helpers (C --> Config)
vim.keymap.set('n', "<leader>ln", "<cmd>Oil " .. vim_config_path .. "<CR>", { desc = "[L]oad the root [n]eovim config directory" })
vim.keymap.set('n', "<leader>lc", "<cmd>Oil ~/.config<CR>", { desc = "[L]oad the [c]onfigurations root" })
vim.keymap.set('n', "<leader>lp", "<cmd>Oil " .. utils.joinPaths(vim_config_path, "lua", "ebeau", "plugins") .. "<CR>", { desc = "[L]oad the directory containing [p]lugins configuration" })
vim.keymap.set('n', "<leader>lk", "<cmd>e " .. utils.joinPaths(vim_config_path, "lua", "ebeau", "core", "keymappings.lua") .. "<CR>", { desc = "[L]oad [k]eymappings.lua" })
vim.keymap.set('n', "<leader>lo", "<cmd>e " .. utils.joinPaths(vim_config_path, "lua", "ebeau", "core", "options.lua") .. "<CR>", { desc = "[L]oad [o]options.lua" })
vim.keymap.set('n', "<leader>lt", "<cmd>e ~/.tmux.conf<CR>", { desc = "[L]oad [t]mux config" })

-- more practical insert mode exit
vim.keymap.set('i', "jk", "<ESC>")
vim.keymap.set('t', "jk", "<C-\\><C-n>", { silent = false })
vim.keymap.set('t', "<C-n>", "<C-\\><C-n>", { silent = false }) -- because 'jk' does not work with zsh terminal

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
vim.keymap.set('n', "<C-Bslash>", "<cmd>vsplit<CR>", { desc = "Split current window vertically and keep buffer" })
vim.keymap.set('n', "<C-|>", "<cmd>split<CR>", { desc = "Split current window horizontally and keep buffer" })
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "[S]plit [V]ertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "[S]plit [H]orizontally" })
vim.keymap.set("n", "<leader>s=", "<C-w>=", { desc = "[S]plit Equally" })
vim.keymap.set("n", "<leader>sx", ":close<CR>", { desc = "[S]plit kill" })
vim.keymap.set("n", "<M-w>", ":close<CR>", { desc = "[S]plit kill" })
vim.keymap.set('n', "<M-f>", "<cmd>lua require('ebeau.core.utils').close_floating_windows()<cr>", {desc = "Close all floating windows"})
-- insert mode cursor move
vim.keymap.set('i', "<C-h>", "<Left>")
vim.keymap.set('i', "<C-j>", "<Down>")
vim.keymap.set('i', "<C-k>", "<Up>")
vim.keymap.set('i', "<C-l>", "<Right>")

-- global clipboard
vim.keymap.set({ 'v', 'n' }, "<leader>cy", '"+y')
vim.keymap.set({ 'v', 'n' }, "<leader>cp", '"+p')
vim.keymap.set('n', "<leader>cP", '"+P', { noremap = false, silent = false })

-- delete text without filling default register
vim.keymap.set('n', "x", '"_x')
vim.keymap.set('x', "<leader>p", '"_dP')
vim.keymap.set({ 'v', 'n' }, "<leader>D", '"_d')

-- increment/decrement
vim.keymap.set('n', '<leader>+', '<C-a>')
vim.keymap.set('n', '<leader>-', '<C-x>')

-- jumps and scrolling
vim.keymap.set('n', "n", "nzzzv")
vim.keymap.set('n', "N", "Nzzz")
--vim.keymap.set('n', "<C-d>", "<C-d>zz")
--vim.keymap.set('n', "<C-u>", "<C-u>zz")
--vim.keymap.set('n', "<C-f>", "<C-f>zz")
--vim.keymap.set('n', "<C-b>", "<C-b>zz")
vim.keymap.set('n', "<C-o>", "<C-o>zz")
vim.keymap.set('n', "<C-i>", "<C-i>zz")
vim.keymap.set('n', "*", "*zz", { noremap = false, silent = false })
vim.keymap.set('n', "#", "#zz", { noremap = false, silent = false })
vim.keymap.set('n', "[[", "[[zz")
vim.keymap.set('n', "]]", "]]zz")
vim.keymap.set('n', "[]", "[]zz")
vim.keymap.set('n', "][", "][zz")
vim.keymap.set('n', "<M-k>", "5<C-y>")
vim.keymap.set('n', "<M-j>", "5<C-e>")
vim.keymap.set('n', "<space>mh", ":execute 'normal! H'<cr>")
vim.keymap.set('n', "<space>mm", ":execute 'normal! M'<cr>")
vim.keymap.set('n', "<space>ml", ":execute 'normal! L'<cr>")

-- location list is local to a buffer (e.g. search results in current file) as opposed to quick-fix which is cross buffer (e.g. project compilation errors)
-- quick-fix list (:copen, :cclose/ccl, etc.) navigation
vim.keymap.set("n", "<F4>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<S-F4>", "<cmd>cprev<CR>zz")
-- location list (:lopen, :lclose/lcl, etc.) navigation
vim.keymap.set("n", "<F3>", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<S-F3>", "<cmd>lprev<CR>zz")

-- folding
--  * zo: Open fold under cursor
--  * zc: Close fold under cursor
--  * zf: fold object
--  * za: Toggle fold in current scope/block
--  * zk: Preview fold under cursor
--  * zA: Toggle fold and sub-folds in current scope/block
--  * zO: Open all folds
--  * zC: close all folds
-- vim.keymap.set('n', "zO", "zR<ESC>")
-- vim.keymap.set('n', "zC", "zM<ESC>")
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

-- make %% in command mode expand to the current file's path
vim.keymap.set('c', "%%", "getcmdtype() == ':' ? expand('%:p:h').'/' : '%%'", { expr = true, noremap = true })
-- make ^^ in command mode expand to the file, sans extension
vim.keymap.set('c', "^^", "getcmdtype() == ':' ? expand('%:p:r') : '^^'", { expr = true, noremap = true })

-- navigate buffers
vim.keymap.set('n', "<M-l>", ":bnext<CR>")
vim.keymap.set('n', "<M-h>", ":bprevious<CR>")

-- stay in visual mode while indenting
vim.keymap.set('v', "<", "<gv")
vim.keymap.set('v', ">", ">gv")

-- formatting
vim.keymap.set("n", "==", vim.lsp.buf.format, { noremap = true, silent = true })
vim.keymap.set({ 'x', 'v' }, "=", vim.lsp.buf.format, { noremap = true, silent = true })

-- file eplorer
vim.keymap.set('n', "<leader>fb", "<cmd>Oil<CR>", { desc = "File Browser" })

-- buffer operations
vim.keymap.set('n', "<leader>bd", "<cmd>bd!<CR>", { desc = "[B]uffer [D]elete" })
vim.keymap.set('n', "<leader>bc", "<cmd>BufDel!<CR>", { desc = "[B]uffer [C]lose" })
vim.keymap.set('n', "<leader>bw", "<cmd>w!<CR>", { desc = "[B]uffer [W]rite" })
vim.keymap.set('n', "<leader>bf", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "[B]uffer [F]uzzy find" })
vim.keymap.set('n', "<leader>bk", "<cmd>%bd|e#|bd#<CR>", { desc = "[B]uffer [K]ill all others" })
vim.keymap.set('n', '<leader>bl', '<Plug>(leap)')

-- Search
vim.keymap.set('n', "<leader>sf", "<cmd>lua require('telescope.builtin').find_files()<cr>", { desc = "[S]earch [F]ile" })
vim.keymap.set('n', "<leader>sb", "<cmd>lua require('telescope.builtin').buffers()<cr>", { desc = "[S]earch [B]uffer" })
vim.keymap.set('n', "<leader>so", "<cmd>Telescope oldfiles<cr>", { desc = "[S]earch [o]ld files" })
vim.keymap.set('n', "<leader>sr", "<cmd>Telescope registers<cr>", { desc = "[S]earch [R]egister" })
vim.keymap.set('n', "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "[S]earch [K]ey remapping" })
vim.keymap.set('n', "<leader>sc", "<cmd>Telescope commands<cr>", { desc = "[S]earch [C]ommand" })
vim.keymap.set('n', "<leader>sC", "<cmd>Telescope colorscheme<cr>", { desc = "[S]earch [C]olor scheme" })
vim.keymap.set('n', "<leader>sM", "<cmd>Telescope man_pages<cr>", { desc = "[S]earch [M]an page" })
vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>",
    { desc = "[S]earch string in current working directory as you type using [G]rep" })
vim.keymap.set('n', "<leader>sd", "<cmd>Telescope diagnostics<cr>", { desc = "[S]earch [D]iagnostics" })

-- Teminal
-- vim.keymap.set('n', "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", {desc="[T]erminal [P]ython"})
-- vim.keymap.set('n', "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", {desc="[T]erminal [F]loat"})
-- vim.keymap.set('n', "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", {desc="[T]erminal [H]orizontal"})
-- vim.keymap.set('n', "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", {desc="[T]erminal [V]ertical"})

-- Workspaces
vim.keymap.set('n', "<leader>wl", "<cmd>Telescope workspaces<CR>", { desc = "List available workspaces" })

-- Cpp man
vim.keymap.set("n", "<leader>cc", function() require('cppman').open_cppman_for(vim.fn.expand("<cword>")) end)
vim.keymap.set("n", "<leader>cm", function() require('cppman').input() end)

-- Quick fix
vim.keymap.set('n', "<leader>ct", "<cmd>lua require('ebeau.core.utils').toggle_qf()<cr>", {
    desc =
    "Toggle quick-fix list"
})

HarpoonDeleteCurrentBuffer = function()
    local harpoon = require("harpoon")
    local file_workspace_path = vim.fn.expand('%')
    local harpoon_item = harpoon:list():get_by_display(file_workspace_path)

    if harpoon_item then
        harpoon:list():remove(harpoon_item)
    end
end

-- Bookmarks
-- m; Toggle mark on current line
-- '<character> : Go to mark with <character> name
-- dm- Remove mark on current line
vim.keymap.set("n", "dm<Space>", '<cmd>delmarks!<cr>')

-- Harpoon
-- 'd' in menu removes the currently selected entry
vim.keymap.set("n", "<leader>ha", '<cmd>lua require("harpoon"):list():append()<cr>')
vim.keymap.set("n", "<leader>hd", '<cmd>lua HarpoonDeleteCurrentBuffer()<cr>')
vim.keymap.set("n", "<leader>ht", '<cmd>lua require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())<cr>')
vim.keymap.set("n", "<M-1>", '<cmd>lua require("harpoon"):list():select(1)<cr>')
vim.keymap.set("n", "<M-2>", '<cmd>lua require("harpoon"):list():select(2)<cr>')
vim.keymap.set("n", "<M-3>", '<cmd>lua require("harpoon"):list():select(3)<cr>')
vim.keymap.set("n", "<M-4>", '<cmd>lua require("harpoon"):list():select(4)<cr>')
vim.keymap.set("n", "<M-5>", '<cmd>lua require("harpoon"):list():select(4)<cr>')

-- Misc
vim.keymap.set('n', "<ESC>", "<cmd>noh<cr>", { desc = "Delete last search highlight" })
vim.keymap.set('n', "<leader>H", "<cmd>Alpha<cr>", { desc = "Show alpha [H]ome page" })
--vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', {noremap = true})
