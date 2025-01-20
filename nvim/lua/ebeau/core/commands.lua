local cmd = vim.cmd

cmd "command! Build :wa | Make"
cmd "command! CargoBuild :wa | Dispatch cargo build"
cmd "command! CargoCheck :wa | Dispatch cargo check"
cmd "command! W :w"

vim.cmd [[ 
  augroup _general_settings
    autocmd!
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o 
  augroup end
]]

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Hide tmux status line when in nvim
local function toggle_tmux_status_bar()
    if vim.g.tmux_status == nil then
        vim.g.tmux_status = 1
    end

    if vim.g.tmux_status == 1 then
        vim.fn.system('tmux set-option -g status off')
        vim.g.tmux_status = 0
    else
        vim.fn.system('tmux set-option -g status on')
        vim.g.tmux_status = 1
    end
end

vim.api.nvim_create_augroup("TmuxStatus", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
    group = "TmuxStatus",
    callback = toggle_tmux_status_bar,
})
vim.api.nvim_create_autocmd("VimLeave", {
    group = "TmuxStatus",
    callback = toggle_tmux_status_bar,
})

