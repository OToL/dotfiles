local status_ok, _ = pcall(require, "exrc")
if not status_ok then
  return
end

vim.o.exrc = false

require("exrc").setup({
  files = {
    ".nvimrc.lua",
    ".nvimrc",
    ".exrc.lua",
    ".exrc",
  },
})
