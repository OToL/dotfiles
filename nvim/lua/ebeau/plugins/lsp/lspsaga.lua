return {
  {
    "glepnir/lspsaga.nvim",
    config = function()

        require("lspsaga").setup({
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
                hide_keyword = true,
                show_file = false,
                folder_level = 0,
                delay = 600,
            },
            lightbulb = {
                enable = false,
                sign = false
            }
        })
    end
  },
}


