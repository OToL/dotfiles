local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---@diagnostic disable-next-line: undefined-field
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

require("lazy").setup(
    {
        { import = "plugins" },
        { import = "plugins.lsp" },
    },
    {
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
            enabled = false,
            notify = false,
        },
    }
)
