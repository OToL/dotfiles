local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

local actions = require "telescope.actions"

telescope.setup {
    defaults = {
        selection_caret = " ",
        prompt_prefix = "🔍 ",
        path_display = { "truncate" },

        file_ignore_patterns = {
            ".build", ".git", ".backup", ".swap", ".langservers", ".session", ".undo",
            ".cache", ".vscode-server", "%.pdb", "%.cab", "%.exe", "%.csv",
            "%.dll", "%.EXE", "%.bl", "%.a", "%.so", "%.lib", "%.msi",
            ".vs", "%.mst", "%.zip", "%.7z", "%.doc", "%.docx"
        },

        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,

                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,

                ["<C-c>"] = actions.delete_buffer,

                ["<C-h>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
            },

            n = {
                ["<esc>"] = actions.close,

                ["<C-h>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,

                ["<C-c>"] = actions.delete_buffer,

                ["j"] = actions.move_selection_next,
                ["k"] = actions.move_selection_previous,

                ["gg"] = actions.move_to_top,
                ["G"] = actions.move_to_bottom,

                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,
            },
        },
    },
}

-- Enable telescope fzf native, if installed
pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "workspaces")

-- my telescopic customizations
local M = {}

function M.get_dropdown()
    local opts = {}

    opts.previewer = false
    opts.layout_config = {
        prompt_position = "top",
        preview_cutoff = 1,
        width = function(_, max_columns, _)
            return math.min(max_columns, 100)
        end,
        height = function(_, _, max_lines)
            return math.min(max_lines, 20)
        end,
    }

    require("telescope.themes").get_dropdown(opts)

    return opts
end

return M

