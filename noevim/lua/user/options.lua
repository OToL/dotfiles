vim.opt.fileencoding="utf-8"            -- the encoding written to a file

vim.opt.hlsearch = false                -- highlight all matches on previous search pattern
vim.opt.incsearch = true                -- performs search while typing
vim.opt.ignorecase = true               -- ignore case when searching
vim.opt.smartcase = true                -- search is case sensitive only when using capitals
vim.opt.showmatch = true                -- shows all matches of the current search

vim.opt.number = true                   -- show line numbers in the margin
vim.opt.relativenumber = true           -- show relative line numbers in the margin
vim.opt.scrolloff = 4                   -- scrolls the text so that there are always at least N lines visible above and below the cursor
vim.opt.visualbell = false              -- enable/disable vim bell

vim.opt.colorcolumn = "150"             -- vertical bar showing max characters per line
vim.opt.signcolumn="yes"                -- always show the sign column, otherwise it would shift the text each time
vim.opt.isfname:append("@-@")

vim.opt.backup = false                  -- creates a backup file
vim.opt.writebackup = false             -- if a file is being edited by another program, it is not allowed to be edited
vim.opt.undofile = true                 -- enable persistent undo i.e. undo history is written to a file
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.swapfile = false                -- creates a swapfile

-- vim.opt.timeoutlen = 1000            -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.updatetime = 250                -- faster completion (4000ms default)
vim.opt.hidden = true                   -- keep buffers opened when switching to another one

vim.opt.expandtab = true                -- convert tabs to spaces
vim.opt.tabstop = 4                     -- insert 4 spaces for a tab
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4                  -- number of spaces inserted for each indentation
vim.opt.autoindent = true               -- copy indent from current line when starting a new line 
vim.opt.smartindent = true              -- indenting behavior depends on the language/context

vim.opt.cursorline = false              -- highlight the current line
vim.opt.showmode = true                 -- show current mode (insert, normal, etc.) at the bottom of the screen
vim.opt.showcmd  = true                 -- show (partial) command in the last line of the screen
vim.opt.wrap = false                    -- display lines as one long line
vim.opt.mouse = "a"                     -- enable mouse usage
vim.opt.splitbelow = true               -- force all horizontal splits to go below current window
vim.opt.splitright = true               -- force all vertical splits to go to the right of current window
vim.opt.guifont = "monospace:h10"       -- the font used in graphical neovim applications
vim.opt.termguicolors = true            -- Enables 24-bit RGB color

vim.cmd "set whichwrap+=h,l"            -- Allow specified keys that move the cursor left/right to move to the previous/next line when the cursor is on the first/last character in the line.
vim.cmd "set exrc"                      -- Allow automatic executation of vim script located at workspace root

