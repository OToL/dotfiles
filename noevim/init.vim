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

syntax on

" When opening vim, automatically source the vimrc in the current folder
" Can be used for having project specific settings
set exrc

colorscheme gruvbox

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
set nohlsearch
set incsearch
set hidden
set showmode
set showcmd 

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
set smartindent

" Show hidden characters
set list
set listchars=tab:→\ ,trail:·,nbsp:·

let mapleader = "\<Space>"
let g:ctrlp_use_caching = 0

inoremap jk <ESC>

nnoremap <C-Tab> :bnext<CR>
nnoremap <S-C-Tab> :bprevious<CR>
nnoremap <Space> <Nop>
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>pf <cmd>Telescope find_files<cr>
nnoremap <leader>pg <cmd>Telescope live_grep<cr>
nnoremap <leader>bf <cmd>Telescope buffers<cr>
nnoremap <leader>f <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>et :NERDTreeToggle<CR>
nnoremap <leader>ef :NERDTreeFind<CR>
nnoremap <expr> <silent> <F4>   (&diff ? "]c" : ":cnext\<CR>")
nnoremap <expr> <silent> <S-F4> (&diff ? "[c" : ":cprev\<CR>")

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
 
