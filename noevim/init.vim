" :PlugInstall to install newly added plugins
call plug#begin("~/AppData/Local/nvim/plugged")
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'morhetz/gruvbox'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'PhilRunninger/nerdtree-buffer-ops'
    Plug 'PhilRunninger/nerdtree-visual-selection'
    Plug 'tpope/vim-dispatch'
call plug#end()

" Disable compatibility with vi which can cause various issues
set nocompatible

" Coloring style
colorscheme gruvbox
syntax on

" Enable file type detection
filetype on
filetype plugin on

" Highlight current line
set cursorline

" When opening vim, automatically source the vimrc in the current folder
" Can be used for having project specific settings
set exrc

" Do not highlight current & last search results
set nohlsearch

" Change the commands history depth (default=20)
set history=1000

" Display command mode completion in a buffer instead of contextual menu
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

set relativenumber
set nu
set scrolloff=4
set visualbell
set ruler
set signcolumn=yes
set colorcolumn=120

set ignorecase
set smartcase
set showmatch
set incsearch
set hidden
set showmode
set showcmd 
set nowrap

" Allow local project settings (.vimrc)
set exrc
"set secure

" No backup
set nobackup
set nowritebackup
set nowb
set noswapfile

" Undo depth
set undolevels=1000
set undodir=~/AppData/Local/nvim/undodir
set undofile

" Tabulation
set expandtab
set tabstop=4 softtabstop=4
set shiftwidth=4
set autoindent
set smartindent

" Show hidden characters
set list
set listchars=tab:→\ ,trail:·,nbsp:·

let mapleader = "\<Space>"
let g:ctrlp_use_caching = 0

inoremap jk <ESC>

" Delete text without changing default target register value 
xnoremap <leader>p "_dp
nnoremap <leader>d "_d
vnoremap <leader>d "_d
vnoremap <leader>d "_d

" Global clipboard
nnoremap <leader>gy "+y
vnoremap <leader>gy "+y
nmap <leader>gY "+Y
nnoremap <leader>gp "+p
vnoremap <leader>gp "+p
nmap <leader>gP "+P

" Center after moves
nnoremap n nzzzv
nnoremap N Nzzz
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap <C-f> <C-f>zz
nnoremap <C-b> <C-b>zz
nmap * *zz
nmap # #zz
cnoremap <silent><expr> <enter> index(['/', '?'], getcmdtype()) >= 0 ? '<enter>zz' : '<enter>'
nnoremap <expr> <silent> <F4>   (&diff ? "]c" : ":cnext\<CR>zz")
nnoremap <expr> <silent> <S-F4> (&diff ? "[c" : ":cprev\<CR>zz")

nnoremap <C-Tab> :bnext<CR>
nnoremap <S-C-Tab> :bprevious<CR>
nnoremap <Space> <Nop>
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>pf <cmd>Telescope find_files<cr>
nnoremap <leader>pg <cmd>Telescope live_grep<cr>
nnoremap <leader>bf <cmd>Telescope buffers<cr>
nnoremap <leader>f <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>et :NERDTreeToggle<CR>
nnoremap <leader>ef :NERDTreeFind<CR>

" Folding
" - zo: open current fold
" - zc: close current fold
" - zO: open all folds
" - zC: close all folds
" - zf: fold
nnoremap zO zR<ESC>
nnoremap zC zM<ESC>
" Yank from cursor to the end of line.
nnoremap Y y$
" Pressing the letter o will open a new line below the current one.
" Exit insert mode after creating a new line above or below the current line.
nnoremap o o<esc>
nnoremap O O<esc>
" Center the cursor vertically when moving to the next word during a search.
nnoremap n nzz
nnoremap N Nzz

" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w><
noremap <c-right> <c-w>>

" Make %% in command mode expand to the current file's path
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:p:h').'/' : '%%'
" Make ^^ in command mode expand to the file, sans extension
cnoremap <expr> ^^ getcmdtype() == ':' ? expand('%:p:r') : '^^'

cabbrev vsb vert sb

lua << EOF 
local actions = require "telescope.actions"
require('telescope').setup {
    defaults = {
        prompt_prefix = "🔍 ",
        initial_mode = "insert",
        color_devicons = true,
        use_less = true,
        file_ignore_patterns = {
            ".git", ".backup", ".swap", ".langservers", ".session", ".undo",
            ".cache", ".vscode-server", "%.pdb", "%.cab", "%.exe", "%.csv",
            "%.dll", "%.EXE", "%.bl", "%.a", "%.so", "%.lib", "%.msi",
            "%.mst", "%.zip", "%.7z", "%.doc", "%.docx"
        },
        extensions = {
            fzf = {
                fuzzy = true,                       -- false will only do exact matching
                override_generic_sorter = false,    -- override the generic sorter
                override_file_sorter = true,        -- override the file sorter
                case_mode = "smart_case",           -- or "ignore_case" or "respect_case"
                                                    -- the default case_mode is "smart_case"
            }   
        }
    }
}
EOF 

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeQuitOnOpen=1
let g:NERDTreeShowBookmarks=1
let g:NERDTreeIgnore=[ '\\.git']
let g:NERDTreeShowHidden=1
let g:NERDTreeIndicatorMapCustom = {
  \ 'Modified'  : 'M',
  \ 'Staged'    : 'S',
  \ 'Untracked' : '*',
  \ 'Renamed'   : 'R',
  \ 'Unmerged'  : 'U',
  \ 'Deleted'   : '!',
  \ 'Dirty'     : 'D',
  \ 'Clean'     : 'C',
  \ 'Ignored'   : 'I',
  \ 'Unknown'   : '?'
\ }

augroup nerdtree_group
    autocmd!
    " Automatically open NERTree at vim startup and change the focus back to the initial buffer
    "autocmd VimEnter * NERDTree | wincmd p
augroup END

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%

" Show the status on the second to last line.
set laststatus=2
 
