local utils = require("user.utils")
local vim_config_path = vim.call("stdpath", "config")

-- prevent space from moving the cursor forward
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- remap space as leader key
vim.g.maplocalleader = " "
vim.g.mapleader = " "

-- lua config file helpers (C --> Config)
vim.keymap.set('n', "<leader>li", "<cmd>e " .. utils.joinPaths(vim_config_path, "init.lua") .. "<CR>", {desc="Open [i]nit.lua root [C]onfig"})
vim.keymap.set('n', "<leader>lI", "<cmd>e " .. utils.joinPaths(vim_config_path, "lua", "user", "init.lua") .. "<CR>", {desc="Open plugins [I]nit.lua [C]onfig"})
vim.keymap.set('n', "<leader>lk", "<cmd>e " .. utils.joinPaths(vim_config_path, "lua", "user", "keymappings.lua") .. "<CR>", {desc="Open [k]eymappings.lua [C]onfig"})
vim.keymap.set('n', "<leader>lp", "<cmd>e " .. utils.joinPaths(vim_config_path, "lua", "user", "plugins.lua") .. "<CR>", {desc="Open [p]lugins.lua [C]onfig"})
vim.keymap.set('n', "<leader>ll", "<cmd>e " .. utils.joinPaths(vim_config_path, "after", "plugin", "lsp.lua") .. "<CR>", {desc="Open [l]sp.lua [C]onfig"})

-- more practical insert mode exit
vim.keymap.set('i', "jk", "<ESC>")
vim.keymap.set('t', "jk", "<C-\\><C-n>", {silent = false})

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
vim.keymap.set('n', "<C-q>", "<C-w>q")
vim.keymap.set('n', "<c-up>", "<c-w>+")
vim.keymap.set('n', "<c-down>", "<c-w>-")
vim.keymap.set('n', "<c-left>", "<c-w><")
vim.keymap.set('n', "<c-right>", "<c-w>>")

-- global clipboard
vim.keymap.set({'v', 'n'}, "<leader>cy", '"+y')
vim.keymap.set({'v', 'n'}, "<leader>cp", '"+p')
vim.keymap.set('n', "<leader>cP", '"+P', { noremap = false, silent = false })

-- delete text without changing default target register value
vim.keymap.set('x', "<leader>p", '"_dP')
vim.keymap.set({'v', 'n'}, "<leader>d", '"_d')

-- jumps and scrolling
vim.keymap.set('n', "n", "nzzzv")
vim.keymap.set('n', "N", "Nzzz")
vim.keymap.set('n', "<C-d>", "<C-d>zz")
vim.keymap.set('n', "<C-u>", "<C-u>zz")
vim.keymap.set('n', "<C-f>", "<C-f>zz")
vim.keymap.set('n', "<C-b>", "<C-b>zz")
vim.keymap.set('n', "<C-o>", "<C-o>zz")
vim.keymap.set('n', "<C-i>", "<C-i>zz")
vim.keymap.set('n', "*", "*zz", { noremap = false, silent = false })
vim.keymap.set('n', "#", "#zz", { noremap = false, silent = false })
vim.keymap.set('n', "[[", "[[zz")
vim.keymap.set('n', "]]", "]]zz")
vim.keymap.set('n', "[]", "[]zz")
vim.keymap.set('n', "][", "][zz")
vim.keymap.set('n', "<A-j>", "<C-y>")
vim.keymap.set('n', "<A-k>", "<C-e>")

-- location list is local to a buffer (e.g. search results in current file) as opposed to quick-fix which is cross buffer (e.g. project compilation errors)
-- quick-fix list (:copen, :cclose/ccl, etc.) navigation
vim.keymap.set("n", "<F4>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<S-F4>", "<cmd>cprev<CR>zz")
-- location list (:lopen, :lclose/lcl, etc.) navigation
vim.keymap.set("n", "<F3>", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<S-F3>", "<cmd>lprev<CR>zz")
-- old quick-fix list navigation hooks
--vim.keymap.set('n', "<F4>", '(&diff ? "]c" : ":cnext<CR>zz")', {expr=true, noremap = true, silent = true})
--vim.keymap.set('n', "<S-F4>", '(&diff ? "[c" : ":cprev<CR>zz")', {expr=true, noremap = true, silent = true})

-- folding
--  * zo: open current fold
--  * zc: close current fold
--  * zO: open all folds
--  * zC: close all folds
--  * zf: fold
vim.keymap.set('n', "zO", "zR<ESC>")
vim.keymap.set('n', "zC", "zM<ESC>")

-- yank from cursor to the end of line
vim.keymap.set('n', "Y", "y$")

-- Cahnge 'o'/'O' to not enter insertion mode after adding line
vim.keymap.set('n', "o", "o<esc>")
vim.keymap.set('n', "O", "O<esc>")
vim.keymap.set('n', "<A-O>", "O")
vim.keymap.set('n', "<A-o>", "o")
vim.keymap.set('i', "<A-O>", "<C-o>O")
vim.keymap.set('i', "<A-o>", "<C-o>o")

-- make %% in command mode expand to the current file's path
vim.keymap.set('c', "%%", "getcmdtype() == ':' ? expand('%:p:h').'/' : '%%'", { expr = true, noremap = true })
-- make ^^ in command mode expand to the file, sans extension
vim.keymap.set('c', "^^", "getcmdtype() == ':' ? expand('%:p:r') : '^^'", { expr = true, noremap = true })

-- navigate buffers
vim.keymap.set('n', "<S-l>", ":bnext<CR>")
vim.keymap.set('n', "<S-h>", ":bprevious<CR>")

-- stay in visual mode while indenting
vim.keymap.set('v', "<", "<gv")
vim.keymap.set('v', ">", ">gv")

-- formatting
vim.keymap.set('n', "==", ":Format<cr>")
vim.keymap.set({'x','v'}, "=", "<esc>:FormatRange<cr>")

-- buffer operations
vim.keymap.set('n', "<leader>bd", "<cmd>bd!<CR>", {desc="[B]uffer [D]elete"})
vim.keymap.set('n', "<leader>bc", "<cmd>BufDel!<CR>", {desc="[B]uffer [C]lose"})
vim.keymap.set('n', "<leader>bw", "<cmd>w!<CR>", {desc="[B]uffer [W]rite"})
vim.keymap.set('n', "<leader>bf", "<cmd>Telescope current_buffer_fuzzy_find<CR>", {desc="[B]uffer [F]uzzy find"})
vim.keymap.set('n', "<leader>bk", "<cmd>%bd|e#|bd#<CR>", {desc="[B]uffer [K]ill all others"})

-- file eplorer
vim.keymap.set('n', "<leader>et", "<cmd>NvimTreeToggle<cr>", {desc="[E]xplorer [T]oggle"})
vim.keymap.set('n', "<leader>ef", "<cmd>NvimTreeFocus<cr>", {desc="[E]xplorer [F]ocus"})

-- Search
vim.keymap.set('n', "<leader>sf", "<cmd>lua require('telescope.builtin').find_files()<cr>", {desc="[S]earch [F]ile"})
vim.keymap.set('n', "<leader>sb", "<cmd>lua require('telescope.builtin').buffers()<cr>", {desc="[S]earch [B]uffer"})
vim.keymap.set('n', "<leader>sr", "<cmd>Telescope oldfiles<cr>", {desc="[S]earch [R]ecently opened files"})
vim.keymap.set('n', "<leader>sR", "<md>Telescope registers<cr>", {desc="[S]earch [R]egister"})
vim.keymap.set('n', "<leader>sk", "<cmd>Telescope keymaps<cr>", {desc="[S]earch [K]ey remapping"})
vim.keymap.set('n', "<leader>sc", "<cmd>Telescope commands<cr>", {desc="[S]earch [C]ommand"})
vim.keymap.set('n', "<leader>sC", "<cmd>Telescope colorscheme<cr>", {desc="[S]earch [C]olor scheme"})
vim.keymap.set('n', "<leader>sh", "<cmd>Telescope help_tags<cr>", {desc="[S]earch [H]elp tag"})
vim.keymap.set('n', "<leader>sm", "<cmd>Telescope man_pages<cr>", {desc="[S]earch [M]an page"})

-- Teminal
--vim.keymap.set('n', "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", {desc="[T]erminal [P]ython"})
vim.keymap.set('n', "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", {desc="[T]erminal [F]loat"})
vim.keymap.set('n', "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", {desc="[T]erminal [H]orizontal"})
vim.keymap.set('n', "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", {desc="[T]erminal [V]ertical"})

-- Packer
vim.keymap.set('n', "<leader>pc", "<cmd>PackerCompile<cr>", {desc="[P]acker [C]ompile"})
vim.keymap.set('n', "<leader>pi", "<cmd>PackerInstall<cr>", {desc="[P]acker [I]nstall"})
vim.keymap.set('n', "<leader>ps", "<cmd>PackerSync<cr>", {desc="[P]acker [S]ync"})
vim.keymap.set('n', "<leader>pS", "<cmd>PackerStatus<cr>", {desc="[P]acker [S]tatus"})
vim.keymap.set('n', "<leader>pu", "<cmd>PackerUpdate<cr>", {desc="[P]acker [U]pdate"})

-- LSP
vim.keymap.set('n', "<leader>Li", "<cmd>LspInfo<cr>", {desc="[L]sp [I]nfo"})

-- Git
vim.keymap.set('n', "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", {desc="[G]it next hunk"})
vim.keymap.set('n', "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", {desc="[G]it previous hunk"})
vim.keymap.set('n', "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", {desc="[G]it [P]review hunk"})
vim.keymap.set('n', "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",{desc="[G]it [R]eset hunk"})
vim.keymap.set('n', "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", {desc="[G]it blame [L]ine"})
vim.keymap.set('n', "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",{desc="[G]it [R]eset buffer"})
vim.keymap.set('n', "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", {desc="[G]it [S]tage hunk"})
vim.keymap.set('n', "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", {desc="[G]it [U]ndo stage hunk"})
vim.keymap.set('n', "<leader>go", "<cmd>Telescope git_status<cr>", {desc="[G]it status"})
vim.keymap.set('n', "<leader>gb", "<cmd>Telescope git_branches<cr>", {desc="[G]it [U]update"})
vim.keymap.set('n', "<leader>gc", "<cmd>Telescope git_commits<cr>", {desc="[G]it [B]ranches"})
vim.keymap.set('n', "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", {desc="[G]it [D]iff head"})

-- Misc
vim.keymap.set('n', "<leader>h", "<cmd>noh<cr>", {desc="Clear last search highlight"})
vim.keymap.set('n', "<leader>;", "<cmd>Alpha<cr>", {desc="Show alpha home page"})
vim.keymap.set('n', "<leader>wl", "<cmd>Telescope workspaces<CR>", {desc="List available workspaces"})

