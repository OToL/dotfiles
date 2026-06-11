vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind == 'delete' then return end

    if name == 'telescope-fzf-native.nvim' then
        local plugin_path = vim.fn.stdpath('data') .. '/site/pack/core/opt/' .. name
        local build_cmd = { vim.o.shell, vim.o.shellcmdflag, 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
        vim.system(build_cmd, { cwd = plugin_path })
    end

    if name == 'nvim-treesitter' and kind == 'update' then
        if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
        vim.cmd('TSUpdate')
    end

end })

local function github(name) return "https://github.com/" .. name end
local function codeberg(name) return "https://codeberg.org/".. name end

-- external plugins
vim.pack.add({
    github("catppuccin/nvim"),
    github("MunifTanjim/nui.nvim"),
    github("numToStr/Comment.nvim"),
    github("stevearc/dressing.nvim"),        -- UI widgets used by other modules e.g. Telescope
    github("MunifTanjim/exrc.nvim"),
    github("j-hui/fidget.nvim"),             -- UI widgets used by lsp e.g. spinning wheels
    github("lukas-reineke/indent-blankline.nvim"),
    github("kylechui/nvim-surround"),
    github("tpope/vim-dispatch"),
    github("NvChad/nvim-colorizer.lua"),
    github("stevearc/oil.nvim"),
    github("nvim-tree/nvim-web-devicons"),
    github("monaqa/dial.nvim"),              -- More increment/decrement e.g. date, boolean, etc.
    github("LunarVim/bigfile.nvim"),
    github("declancm/maximize.nvim"),
    -- github("lewis6991/gitsigns.nvim"),
    github("kevinhwang91/promise-async"),
    github("chentoast/marks.nvim"),
    github("nvim-telescope/telescope-live-grep-args.nvim"),
    github("nvim-lua/plenary.nvim"),
    github("nvim-telescope/telescope-fzf-native.nvim"),
    { src = github("nvim-treesitter/nvim-treesitter"), version = "main" },
    { src = github("nvim-treesitter/nvim-treesitter-textobjects"), version = "main" },
    { src = github("ColinKennedy/mega.logging"), version = vim.version.range('1.x') },
    github("nvim-neotest/nvim-nio"),
    github("ColinKennedy/mega.cmdparse"),
    github("windwp/nvim-autopairs"),
    github("rcarriga/nvim-dap-ui"),
    github("mfussenegger/nvim-dap-python"),
    github("jake-stewart/multicursor.nvim"),
    github("tpope/vim-repeat"),
    github("mrjones2014/smart-splits.nvim"),

    github("mfussenegger/nvim-dap"),
    github("williamboman/mason.nvim"),
    github("WhoIsSethDaniel/mason-tool-installer.nvim"),
    github("rmccord7/p4.nvim"),              -- depends on mega.*, nio, telescope
    github("nvim-telescope/telescope.nvim"),
    github("kevinhwang91/nvim-ufo"),         -- depends on promise async
    github("echasnovski/mini.statusline"),   -- depends on web devicons
    github("madskjeldgaard/cppman.nvim"),    -- depends on nui
    github("akinsho/bufferline.nvim"),       -- depends on webicons
    github("ray-x/lsp_signature.nvim"),
    codeberg("andyg/leap.nvim"),
})

-- internal opt-in plugins
vim.cmd.packadd("nvim.undotree")

--------------------------------------------------------------------------------------------------------
---                                                                                                  --- 
---                                        CONFIGS                                                   ---
---                                                                                                  ---
--------------------------------------------------------------------------------------------------------
require("ibl").setup({
   indent = { char = "┊" },
})
require("nvim-web-devicons").set_icon({
    gql = {
        icon = "",
        color = "#e535ab",
        cterm_color = "199",
        name = "GraphQL",
    },
})
require("configs.mini_statusline").setup()
require("configs.maximize").setup()
require("configs.dial").setup()
require("configs.oil").setup()
require("configs.telescope").setup()
require("configs.autopairs").setup()
require("configs.multicursor").setup()
require("configs.dap").setup()
require("colorizer").setup()
require("fidget").setup()
require("Comment").setup()
require("catppuccin").setup()

-- has to be before buffer line
vim.cmd.colorscheme("catppuccin")

require("bufferline").setup({ highlights = require("catppuccin.special.bufferline").get_theme() })
require('bigfile').setup({filesize = 10})
-- require('gitsigns').setup()

-- requires disabling built-in vim `exrc` (see options.lua)
require("exrc").setup({
  files = {
    ".nvim.lua",
    ".nvimrc.lua",
    ".nvimrc",
    ".exrc.lua",
    ".exrc",
}})

require("leap")
    vim.keymap.set('n', "<leader>bl", "<Plug>(leap)")
    vim.keymap.set('n', "<leader>bL", "<Plug>(leap-anywhere)")

require("ufo").setup({})
    vim.keymap.set('n', "zO", "<cmd>lua require('ufo').openAllFolds()<CR>", { desc = "Open all folds" })
    vim.keymap.set('n', "zC", "<cmd>lua require('ufo').closeAllFolds()<CR>", { desc = "Close all folds" })
    vim.keymap.set('n', "zk", "<cmd>lua require('ufo').peekFoldedLinesUnderCursor()<CR>", { desc = "Preview folded block" })

require('smart-splits').setup(
    {
        multiplexer_backend = 'wezterm',
        disable_multiplexer_nav_when_zoomed = false,
    })
    vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
    vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
    vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
    vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
    vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)

require("marks").setup({
    force_write_shada = true,
    mappings =
    {
        next = "]b",
        prev = "[b",
    }
    })
    vim.keymap.set('n', "<leader>sM", ":Telescope marks<cr>")

require("configs.treesitter").setup()

require("mason").setup({
    ui = { icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } }
})
require("mason-tool-installer").setup({
    ensure_installed = {
        -- LSP servers
        'lua-language-server',
        'rust-analyzer',
        'clangd',
        'json-lsp',
        'html-lsp',
        'cmake-language-server',
        'pyright',
        -- formatters / linters
        'black',
        'mypy',
        'pylint',
        'isort',
        -- debuggers
        'debugpy',
        'codelldb',
        'cpptools',
    }
})
require("configs.lsp").setup()
