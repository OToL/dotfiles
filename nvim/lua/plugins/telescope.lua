local make_exe
local build_cmd

if (string.match(vim.loop.os_uname().sysname, "^Windows")) then
    make_exe = 'cmake'
    build_cmd =
    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
else
    make_exe = 'make'
    build_cmd = 'make'
end

return {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
        "natecraddock/workspaces.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        -- "nvim-telescope/telescope-file-browser.nvim",
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = build_cmd,
            cond = function()
                return vim.fn.executable(make_exe) == 1
            end
        },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local lga_actions = require("telescope-live-grep-args.actions")
        -- local fb_actions = telescope.extensions.file_browser.actions

        telescope.setup {
            defaults = {
                vimgrep_arguments = {
                    'rg',
                    '--no-ignore', -- don't respect .gitignore
                    '--hidden',    -- include dotfiles
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--smart-case',
                    '--color=never',
                },

                selection_caret = " ",
                prompt_prefix = "🔍 ",
                path_display = { "truncate" },

                -- "%.o",
                file_ignore_patterns = {
                    ".git", ".backup", ".swap", ".langservers", ".session", ".undo",
                    ".cache", ".vscode-server", "%.pdb", "%.cab", "%.exe", "%.csv",
                    "%.dll", "%.EXE", "%.bl", "%.a", "%.so", "%.lib", "%.msi",
                    ".vs", "%.mst", "%.zip", "%.7z", "%.doc", "%.docx", "%.obj", "%.lib",
                    "%.a", "%.bin"
                },

                mappings = {
                    i = {
                        ["<M-w>"] = actions.close,

                        --["<C-j>"] = actions.move_selection_next,
                        --["<C-k>"] = actions.move_selection_previous,
                        ["<Down>"] = actions.move_selection_next,
                        ["<Up>"] = actions.move_selection_previous,

                        ["<C-u>"] = actions.preview_scrolling_up,
                        ["<C-d>"] = actions.preview_scrolling_down,

                        ["<C-c>"] = actions.delete_buffer,

                        --["<C-h>"] = actions.select_horizontal,
                        ["<C-v>"] = actions.select_vertical,
                    },

                    n = {
                        ["<M-w>"] = actions.close,

                        --["<C-h>"] = actions.select_horizontal,
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
                    mappings = {         -- extend mappings
                        i = {
                            ["<C-k>"] = lga_actions.quote_prompt(),
                            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                            -- freeze the current list and start a fuzzy search in the frozen list
                            ["<C-space>"] = actions.to_fuzzy_refine,
                        },
                    },
                    -- ... also accepts theme settings, for example:
                    -- theme = "dropdown", -- use dropdown theme
                    -- theme = { }, -- use own theme spec
                    -- layout_config = { mirror=true }, -- mirror preview pane
                }
            }
        }

        -- Enable telescope extensions
        telescope.load_extension("fzf")
        telescope.load_extension("workspaces")
        telescope.load_extension("live_grep_args")
        -- telescope.load_extension("file_browser")
    end,
}
