-- more key mappings can be found in 'whichkey.lua

-- noremap=true means that the command is not recursively expanded based on other remap
local default_opts = { noremap = true, silent = false }
local term_opts = { silent = false }
local map = vim.api.nvim_set_keymap

-- prevent space from moving the cursor forward
map("", "<space>", "<nop>", default_opts)
-- remap space as leader key
vim.g.maplocalleader = " "
vim.g.mapleader = " "

-- normal mode remap
local function nmap(shortcut, command, opts)
  map('n', shortcut, command, opts)
end

-- insert mode remap
local function imap(shortcut, command, opts)
  map('i', shortcut, command, opts)
end

-- terminal mode remap
local function tmap(shortcut, command, opts)
  map('t', shortcut, command, opts)
end

-- visual mode remap
local function vmap(shortcut, command, opts)
  map('v', shortcut, command, opts)
end

-- visual block mode remap
local function xmap(shortcut, command, opts)
  map('x', shortcut, command, opts)
end

-- command mode remap
local function cmap(shortcut, command, opts)
  map('c', shortcut, command, opts)
end

------------
-- NEOVIM --
------------

-- more practical insert mode exit
imap("jk", "<ESC>", default_opts)
tmap("jk", "<C-\\><C-n>", term_opts)

-- visual studio block move up/down
vmap("J", ":m '>+1<CR>gv=gv", default_opts)
vmap("K", ":m '<-2<CR>gv=gv", default_opts)

-- keep the cursor at its current position after joing lines
nmap("J", "mzJ`z", default_opts)

-- simpler windows navigation
nmap("<leader>h", "<C-w>h", default_opts)
nmap("<leader>j", "<C-w>j", default_opts)
nmap("<leader>k", "<C-w>k", default_opts)
nmap("<leader>l", "<C-w>l", default_opts)

-- global clipboard
nmap("<leader>cy", '"+y', default_opts)
vmap("<leader>cy", '"+y', default_opts)
nmap("<leader>cp", '"+p', default_opts)
vmap("<leader>cp", '"+p', default_opts)
nmap("<leader>cP", '"+P', {noremap = false, silent = false})

-- delete text without changing default target register value 
xmap("<leader>p", '"_dP', default_opts)
nmap("<leader>d", '"_d', default_opts)
vmap("<leader>d", '"_d', default_opts)

-- center after moves
nmap("n", "nzzzv", default_opts)
nmap("N", "Nzzz", default_opts)
nmap("<C-d>", "<C-d>zz", default_opts)
nmap("<C-u>", "<C-u>zz", default_opts)
nmap("<C-f>", "<C-f>zz", default_opts)
nmap("<C-b>", "<C-b>zz", default_opts)
nmap("<C-o>", "<C-o>zz", default_opts)
nmap("<C-i>", "<C-i>zz", default_opts)
nmap("*", "*zz", {noremap = false, silent = false})
nmap("#", "#zz", {noremap = false, silent = false})
nmap("[[", "[[zz", default_opts)
nmap("]]", "]]zz", default_opts)
nmap("[]", "[]zz", default_opts)
nmap("][", "][zz", default_opts)

-- location list is local to a buffer (e.g. search results in current file) as opposed to quick-fix which is cross buffer (e.g. project compilation errors)
-- quick-fix list (:copen, :cclose/ccl, etc.) navigation
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
-- location list (:lopen, :lclose/lcl, etc.) navigation
vim.keymap.set("n", "<A-j>", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<A-k>", "<cmd>lprev<CR>zz")
-- old quick-fix list navigation hooks
-- nmap("<F4>", '(&diff ? "]c" : ":cnext<CR>zz")', {expr=true, noremap = true, silent = true})
-- nmap("<S-F4>", '(&diff ? "[c" : ":cprev<CR>zz")', {expr=true, noremap = true, silent = true})

-- folding
--  * zo: open current fold
--  * zc: close current fold
--  * zO: open all folds
--  * zC: close all folds
--  * zf: fold
nmap("zO", "zR<ESC>", default_opts)
nmap("zC", "zM<ESC>", default_opts)

-- yank from cursor to the end of line
nmap("Y", "y$", default_opts)

-- Cahnge 'o'/'O' to not enter insertion mode after adding line
nmap("o", "o<esc>", default_opts)
nmap("O", "O<esc>", default_opts)
nmap("<A-O>", "O", default_opts)
nmap("<A-o>", "o", default_opts)
imap("<A-O>", "<C-o>O", default_opts)
imap("<A-o>", "<C-o>o", default_opts)

-- resize split windows using arrow keys by pressing:
nmap("<c-up>", "<c-w>+", default_opts)
nmap("<c-down>" , "<c-w>-", default_opts)
nmap("<c-left>", "<c-w><", default_opts)
nmap("<c-right>", "<c-w>>", default_opts)

-- make %% in command mode expand to the current file's path
cmap("%%", "getcmdtype() == ':' ? expand('%:p:h').'/' : '%%'", {expr=true, noremap = true})
-- make ^^ in command mode expand to the file, sans extension
cmap("^^", "getcmdtype() == ':' ? expand('%:p:r') : '^^'", {expr=true, noremap = true})

-- navigate buffers
nmap("<S-l>", ":bnext<CR>", default_opts)
nmap("<S-h>", ":bprevious<CR>", default_opts)

-- stay in visual mode while indenting
vmap("<", "<gv", default_opts)
vmap(">", ">gv", default_opts)

-- formatting
nmap("==", ":Format<cr>", default_opts)
vmap("=", "<esc>:FormatRange<cr>", default_opts)
xmap("=", "<esc>:FormatRange<cr>", default_opts)

