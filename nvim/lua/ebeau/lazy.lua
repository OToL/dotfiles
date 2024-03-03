local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
        spec = LAZY_PLUGIN_SPEC,
        install = {
            colorscheme = { "catppuccin" },
        },
        -- always check for updates but do not notify
        checker = {
            enabled = true,
            notify = false,
        },
        -- silent notification from Lazy when changing a plugin file
        change_detection = {
            notify = false,
        },
    })
