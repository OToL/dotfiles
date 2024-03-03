vim.opt.fileencoding="utf-8"            -- the encoding written to a file
vim.opt.clipboard:append("unnamedplus") -- allows neovim to access the system clipboard
vim.opt.visualbell = false              -- enable/disable vim bell

vim.opt.hlsearch = true                 -- highlight all matches on previous search pattern
vim.opt.incsearch = true                -- performs search while typing
vim.opt.ignorecase = true               -- ignore case when searching
vim.opt.smartcase = true                -- search is case sensitive only when using capitals
vim.opt.showmatch = true                -- shows all matches of the current search

vim.opt.number = true                   -- show line numbers in the margin
vim.opt.numberwidth = 1                 -- set number column width {default 4}
vim.opt.relativenumber = true           -- show relative line numbers in the margin

vim.opt.scrolloff = 4                   -- scrolls the text so that there are always at least N lines visible above and below the cursor
vim.opt.sidescrolloff = 4               -- scrolls the text so that there are always at least N lines visible to the left and right of the cursor
vim.opt.colorcolumn = "150"             -- vertical bar showing max characters per line
vim.opt.signcolumn="yes"                -- always show the sign column, otherwise it would shift the text each time

vim.opt.backup = false                  -- creates a backup file
vim.opt.writebackup = false             -- if a file is being edited by another program, it is not allowed to be edited
vim.opt.undofile = true                 -- enable persistent undo i.e. undo history is written to a file
vim.opt.swapfile = false                -- creates a swapfile

vim.opt.autoindent = true               -- copy indent from current line when starting a new line 
vim.opt.smartindent = true              -- indenting behavior depends on the language/context
vim.opt.expandtab = true                -- convert tabs to spaces
vim.opt.tabstop = 4                     -- insert 4 spaces for a tab
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4                  -- number of spaces inserted for each indentation
vim.opt.smartindent = true              -- indenting behavior depends on the language/context

vim.opt.updatetime = 250                -- faster completion (4000ms default)
vim.opt.hidden = true                   -- keep buffers opened when switching to another one
vim.opt.cursorline = true               -- highlight the current line
vim.opt.showmode = false                -- show current mode (insert, normal, etc.) at the bottom of the screen
vim.opt.showcmd  = true                 -- show (partial) command in the last line of the screen
vim.opt.wrap = false                    -- display lines as one long line
vim.opt.mouse = "a"                     -- enable mouse usage

vim.opt.splitbelow = true               -- force all horizontal splits to go below current window
vim.opt.splitright = true               -- force all vertical splits to go to the right of current window
vim.opt.termguicolors = true            -- Enables 24-bit RGB color

vim.opt.iskeyword:append("-")           -- consider string-string as whole word
vim.opt.isfname:append("@-@")
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.cmd "set whichwrap+=h,l"            -- Allow specified keys that move the cursor left/right to move to the previous/next line when the cursor is on the first/last character in the line.
vim.cmd "set exrc"                      -- Allow automatic executation of vim script located at workspace root

-- Settings required by nvim-ufo
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Same list as vim-dispatch but without 'tmux'
-- I have removed it because it is causing all panes to show up when invoking :Make
vim.cmd "let g:dispatch_handlers = ['job', 'screen', 'terminal', 'windows', 'iterm', 'x11', 'headless']"
