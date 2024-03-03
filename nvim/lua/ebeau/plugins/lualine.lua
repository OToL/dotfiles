return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- same as require("bufferline").setup(opts)
    config = function()
        -- get lualine nightfly theme
        local lualine_nightfly = require("lualine.themes.nightfly")
        -- to configure lazy pending updates count
        local lazy_status = require("lazy.status")
        local lualine = require("lualine")

        -- new colors for theme
        local new_colors = {
            blue = "#65D1FF",
            green = "#3EFFDC",
            violet = "#FF61EF",
            yellow = "#FFDA7B",
            black = "#000000",
        }

        -- change nightlfy theme colors
        lualine_nightfly.normal.a.bg = new_colors.blue
        lualine_nightfly.insert.a.bg = new_colors.green
        lualine_nightfly.visual.a.bg = new_colors.violet
        lualine_nightfly.command = {
            a = {
                gui = "bold",
                bg = new_colors.yellow,
                fg = new_colors.black, -- black
            },
        }

        local hide_in_width = function()
            return vim.fn.winwidth(0) > 80
        end

        local diagnostics = {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            sections = { "error", "warn" },
            symbols = { error = " ", warn = " " },
            colored = false,
            update_in_insert = false,
            always_visible = true,
        }

        local diff = {
            "diff",
            colored = false,
            symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
            cond = hide_in_width
        }

        local filename = {
            'filename',
            file_status = true,     -- Displays file status (readonly status, modified status)
            newfile_status = false, -- Display new file status (new file means no write after created)
            path = 1,               -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory

            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
            -- for other components. (terrible name, any suggestions?)
            symbols = {
                modified = '[+]',      -- Text to show when the file is modified.
                readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
                unnamed = '[No Name]', -- Text to show for unnamed buffers.
                newfile = '[New]',     -- Text to show for new created file before first writting
            }
        }

        local branch = {
            "branch",
            icons_enabled = true,
            icon = "",
        }

        lualine.setup({
            options = {
                theme = lualine_nightfly,
                disabled_filetypes = { "alpha", "dashboard", "Outline" },
                icons_enabled = true,
            },
            sections = {
                lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 }, },
                lualine_b = { branch, diagnostics },
                lualine_c = { filename },
                lualine_x = {
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                        color = { fg = "#ff9e64" },
                    },
                    diff,
                    {"encoding"},
                    {"fileformat"},
                    {"filetype"},
                },
                lualine_y = { },
                lualine_z = { { 'location', separator = { right = '' }, left_padding = 2 }, },
            },
        })
    end
}

