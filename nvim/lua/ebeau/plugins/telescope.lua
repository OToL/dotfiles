local status_telescope_ok, telescope = pcall(require, "telescope")
if not status_telescope_ok then
    return
end

local status_lga_ok, lga_actions = pcall(require, "telescope-live-grep-args.actions")
if not status_lga_ok then
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
            ".vs", "%.mst", "%.zip", "%.7z", "%.doc", "%.docx", "%.obj", "%.lib"
        },

        mappings = {
            i = {
                ["<M-w>"] = actions.close,

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
                ["<M-w>"] = actions.close,

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
    extensions = {
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          -- define mappings, e.g.
          mappings = { -- extend mappings
            i = {
              ["<A-k>"] = lga_actions.quote_prompt(),
              ["<A-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
            },
          },
          -- ... also accepts theme settings, for example:
          -- theme = "dropdown", -- use dropdown theme
          -- theme = { }, -- use own theme spec
          -- layout_config = { mirror=true }, -- mirror preview pane
        }
  }}

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

