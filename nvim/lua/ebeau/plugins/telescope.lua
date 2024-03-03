return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "natecraddock/workspaces.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-telescope/telescope-file-browser.nvim",
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local lga_actions = require("telescope-live-grep-args.actions")
        local fb_actions = telescope.extensions.file_browser.actions

        telescope.setup {
            defaults = {
                selection_caret = " ",
                prompt_prefix = "🔍 ",
                path_display = { "truncate" },

                file_ignore_patterns = {
                    ".git", ".backup", ".swap", ".langservers", ".session", ".undo",
                    ".cache", ".vscode-server", "%.pdb", "%.cab", "%.exe", "%.csv",
                    "%.dll", "%.EXE", "%.bl", "%.a", "%.so", "%.lib", "%.msi",
                    ".vs", "%.mst", "%.zip", "%.7z", "%.doc", "%.docx", "%.obj", "%.lib", "%.o",
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
                file_browser =
                {
                    mappings =
                    {
                        n =
                        {
                            ["<bs>"]  = fb_actions.goto_parent_dir,
                            ["<A-a>"] = fb_actions.create,
                            ["<A-y>"] = fb_actions.copy,
                            ["<A-m>"] = fb_actions.move,
                            ["<A-r>"] = fb_actions.rename,
                            ["<A-d>"] = fb_actions.remove,
                            ["<C-w>"] = fb_actions.goto_cwd,
                            ["<C-f>"] = fb_actions.toggle_browser,
                            ["<C-g>"] = fb_actions.goto_parent_dir,
                            ["<C-h>"] = fb_actions.toggle_hidden,
                            ["<C-a>"] = fb_actions.select_all,
                            -- open using system editor
                            ["<C-o>"] = fb_actions.open,
                            ["<C-l> "] = function()
                                local entry = require("telescope.actions.state").get_selected_entry()
                                local cb_opts = vim.opt.clipboard:get()
                                if vim.tbl_contains(cb_opts, "unnamed") then vim.fn.setreg("*", entry.path) end
                                if vim.tbl_contains(cb_opts, "unnamedplus") then
                                    vim.fn.setreg("+", entry.path)
                                end
                                vim.fn.setreg("", entry.path)
                            end,
                            ["<C-y>"] = function()
                                local entry = require("telescope.actions.state").get_selected_entry()
                                local cb_opts = vim.opt.clipboard:get()
                                local filename = vim.fn.fnamemodify(entry.path, ":t")
                                if vim.tbl_contains(cb_opts, "unnaed") then vim.fn.setreg("*", filename) end
                                if vim.tbl_contains(cb_opts, "unnamedplus") then
                                    vim.fn.setreg("+", filename)
                                end
                                vim.fn.setreg("", filename)
                            end,
                        },
                        i =
                        {
                            ["<A-a>"] = fb_actions.create,
                            ["<A-p>"] = fb_actions.copy,
                            ["<C-bs>"] = fb_actions.goto_parent_dir,
                            ["<C-a>"] = fb_actions.select_all,
                            ["<C-l>"] = function()
                                local entry = require("telescope.actions.state").get_selected_entry()
                                local cb_opts = vim.opt.clipboard:get()
                                if vim.tbl_contains(cb_opts, "unnamed") then vim.fn.setreg("*", entry.path) end
                                if vim.tbl_contains(cb_opts, "unnamedplus") then
                                    vim.fn.setreg("+", entry.path)
                                end
                                vim.fn.setreg("", entry.path)
                            end,
                            ["<C-y>"] = function()
                                local entry = require("telescope.actions.state").get_selected_entry()
                                local cb_opts = vim.opt.clipboard:get()
                                local filename = vim.fn.fnamemodify(entry.path, ":t")
                                if vim.tbl_contains(cb_opts, "unnaed") then vim.fn.setreg("*", filename) end
                                if vim.tbl_contains(cb_opts, "unnamedplus") then
                                    vim.fn.setreg("+", filename)
                                end
                                vim.fn.setreg("", filename)
                            end,
                        }
                    }
                },
                live_grep_args = {
                    auto_quoting = true, -- enable/disable auto-quoting
                    -- define mappings, e.g.
                    mappings = {         -- extend mappings
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
            }
        }

        -- Enable telescope extensions
        telescope.load_extension("fzf")
        telescope.load_extension("workspaces")
        telescope.load_extension("file_browser")
    end,
}
