local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
    return
end

vim.g.indent_blankline_use_treesitter = true

indent_blankline.setup({
    char = '┊',
    show_trailing_blankline_indent = false,
})
