return {
    'echasnovski/mini.statusline',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local statusline = require('mini.statusline')
        -- Customized because, by default, mini statusline plugin does not show macro recording status which can be misleading
        -- because it breaks INSERT mode auto-completion
        statusline.setup({
            content = {
                active = function()
                    local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
                    local git           = statusline.section_git({ trunc_width = 75 })
                    local diagnostics   = statusline.section_diagnostics({ trunc_width = 75 })
                    local filename      = statusline.section_filename({ trunc_width = 140 })
                    local fileinfo      = statusline.section_fileinfo({ trunc_width = 120 })
                    local location      = statusline.section_location({ trunc_width = 75 })
                    local search        = statusline.section_searchcount({ trunc_width = 75 })

                    -- Add recording indicator
                    local recording = vim.fn.reg_recording()
                    if recording ~= '' then
                        recording = ' RECORDING @' .. recording
                    end

                    return statusline.combine_groups({
                        { hl = mode_hl,                  strings = { mode } },
                        { hl = 'MiniStatuslineDevinfo',  strings = { git, diagnostics } },
                        '%<', -- Mark general truncate point
                        { hl = 'MiniStatuslineFilename', strings = { filename } },
                        '%=', -- End left alignment
                        { hl = 'MiniStatuslineFilename', strings = { recording } },
                        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                        { hl = mode_hl,                  strings = { search, location } },
                    })
                end,
            },
        })
    end,
}
