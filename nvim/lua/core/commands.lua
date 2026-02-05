local cmd = vim.cmd

-- TODO(ebeau): rework using vim.cmd
cmd "command! Build silent! wa | Make"
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

-- Add to your init.lua or a separate config file
vim.api.nvim_create_user_command('TSStatus', function()
    local buf = vim.api.nvim_get_current_buf()
    local highlighter = vim.treesitter.highlighter.active[buf]

    if highlighter then
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        print("✓ Treesitter is active for: " .. (lang or vim.bo[buf].filetype))
    else
        print("✗ Treesitter is NOT active for this buffer")
    end
end, {})

-- close all buffers which are not from the current workspace
vim.api.nvim_create_user_command("BufCloseNonWorkspace", function()
    local cwd = vim.fs.normalize(vim.fn.getcwd())
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        local name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
        if name ~= "" and not name:find(cwd, 1, true) then
          vim.api.nvim_buf_delete(buf, { force = false })
        end
      end
    end
  end, {})
