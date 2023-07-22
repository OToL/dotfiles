
-- Setup nvim-cmp.
local status_ok, cybu = pcall(require, "cybu")
if not status_ok then
  return
end

cybu.setup()

vim.api.nvim_set_hl(0, "CybuFocus", {
  fg = vim.api.nvim_get_hl_by_name("Normal", true).foreground,
  bg = vim.api.nvim_get_hl_by_name("Visual", true).background,
})

vim.keymap.set("n", "[b", "<Plug>(CybuPrev)")
vim.keymap.set("n", "]b", "<Plug>(CybuNext)")
vim.keymap.set("n", "<c-s-tab>", "<plug>(CybuLastusedPrev)")
vim.keymap.set("n", "<c-tab>", "<plug>(CybuLastusedNext)")

