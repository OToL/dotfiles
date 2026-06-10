--------------------------------------------------------------------------------------------------------
---                                                                                                  --- 
---                                         COMMANDS                                                 ---
---                                                                                                  ---
--------------------------------------------------------------------------------------------------------

vim.api.nvim_create_user_command('ToggleDiag', function ()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Toggling diagnostics status.' })

vim.api.nvim_create_user_command('W', function()
    vim.cmd.w()
end, {})

vim.api.nvim_create_user_command('Build', function()
    vim.cmd({ cmd = 'wa', mods = { silent = true, emsg_silent = true } })
    vim.cmd.Make()
end, {})

vim.api.nvim_create_user_command('CargoCheck', function()
    vim.cmd.wa()
    vim.cmd.Dispatch('cargo check')
end, {})

vim.api.nvim_create_user_command('CargoBuild', function()
    vim.cmd.wa()
    vim.cmd.Dispatch('cargo build')
end, {})

vim.api.nvim_create_user_command('PackUpdate', function()
    vim.pack.update()
end, {})

vim.api.nvim_create_user_command('PackDelete', function(opts)
    vim.pack.del({ opts.args })
end, { nargs = 1 })

vim.api.nvim_create_user_command('PackAdd', function(opts)
    vim.pack.add({ opts.args })
end, { nargs = 1 })


vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  augroup end
]]

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

--------------------------------------------------------------------------------------------------------
---                                                                                                  --- 
---                                    AUTO COMMANDS                                                 ---
---                                                                                                  ---
--------------------------------------------------------------------------------------------------------

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

-- Filter out terminal from buffer list
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.buflisted = false
  end,
})
