-- main commands
--   * PackerSync : update packages
--   * PackerInstall : install missing packages
--   * PackerClean : remove unused and disabled packages
local fn = vim.fn

-- automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

-- install your plugins here
return packer.startup(function(use)
    -- Packer is managing itself
    use 'wbthomason/packer.nvim'

    -- compile script plugins to speed-up loadings
    use "lewis6991/impatient.nvim"

    -- asynchronous 'make' (:Make)
    use "tpope/vim-dispatch"

    -- exrc: automatically execute specific files located in workspace root
    use "MunifTanjim/nui.nvim"
    use "MunifTanjim/exrc.nvim"

    -- home screen
    use "goolord/alpha-nvim"

    -- telescope: Fuzzy Finder (files, lsp, etc)
    use {
        'nvim-telescope/telescope.nvim',
        --tag = '0.1.0',
        --branch = '0.1.x',
        requires = { 'nvim-lua/plenary.nvim' }
    }
    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    }
    use "nvim-telescope/telescope-live-grep-args.nvim"

    -- fency status line
    use "nvim-lualine/lualine.nvim"

    -- BufDel command
    use "ojroques/nvim-bufdel"

    -- tab for buffers
    use "akinsho/bufferline.nvim"

    -- file system explorer
    use "kyazdani42/nvim-tree.lua"

    -- additional icons for various other plugins
    use "kyazdani42/nvim-web-devicons"

    -- pop-up utilities
    use "nvim-lua/popup.nvim"

    -- easily surround text objects and selection
    use "kylechui/nvim-surround"

    -- comments
    use "numToStr/Comment.nvim"

    -- shows identations and other usually invisible characters (e.g. space, line break, etc.)
    use "lukas-reineke/indent-blankline.nvim"

    -- integrated terminal
    use "akinsho/toggleterm.nvim"

    -- auto pair for various special characters e.g. (), {}, etc.
    use "windwp/nvim-autopairs"

    -- git
    use "lewis6991/gitsigns.nvim"

    -- tree sitter
    use { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
    }

    use { -- Additional text objects via treesitter
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter',
    }

    use { -- Keep the current function signature visible
        'nvim-treesitter/nvim-treesitter-context',
        after = 'nvim-treesitter',
    }

    -- workspace management
    use "natecraddock/workspaces.nvim"

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },

            -- Useful status updates for LSP
            'j-hui/fidget.nvim',

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }

    use({
        'ray-x/navigator.lua',
        requires = {
            { 'ray-x/guihua.lua',     run = 'cd lua/fzy && make' },
            { 'ray-x/lsp_signature.nvim' },
            { 'neovim/nvim-lspconfig' },
        },
    })

    -- colorschemes
    use 'folke/tokyonight.nvim'
    use 'navarasu/onedark.nvim'
    use 'ray-x/aurora'
    use 'ray-x/starry.nvim'

    -- automatically set up your configuration after cloning packer.nvim
    -- must be placed after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
