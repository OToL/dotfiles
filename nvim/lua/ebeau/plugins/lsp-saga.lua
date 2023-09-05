local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
    return
end

saga.setup({
    -- keybinds for navigation in lspsaga window
    scroll_preview = { scroll_down = "<C-d>", scroll_up = "<C-u>" },
    -- use enter to open file with definition preview
    definition = {
        edit = "<CR>",
        keys = {
            close = '<M-w>'
        }
    },
    ui = {
        colors = {
            normal_bg = "#022746",
        },
    },
    finder = {
        layout = 'float'
    },
    code_action = {
        enable = false,
        keys = {
            quit = '<M-w>'
        }
    },
    -- shows path to the symbols at the top includindg file, folder, etc.
    symbol_in_winbar = {
        enable = true,
    },
    lightbulb = {
        enable = true,
        sign = false
    }
}
)
