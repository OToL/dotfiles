-- file manager
return {
    'stevearc/oil.nvim',
    event = "VimEnter",
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup({
            -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
            delete_to_trash = true,
            -- Set to false to disable all of the above keymaps
            use_default_keymaps = true,
            -- Set to true to watch the filesystem for changes and reload oil
            experimental_watch_for_changes = true,
            keymaps = {
                ["g?"] = "actions.show_help",
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
                ["g\\"] = "actions.toggle_trash",
                ["gh"] = "actions.open_cwd",
                ["<CR>"] = "actions.select",
                ["<BS>"] = "actions.parent",
                ["<C-v>"] = "actions.select_vsplit",
                ["<C-h>"] = "actions.select_split",
                ["<C-t>"] = "actions.select_tab",
                ["<C-p>"] = "actions.preview",
                ["<C-r>"] = "actions.refresh",
                ["<M-w>"] = "actions.close",
                ["J"] = "actions.preview_scroll_down",
                ["K"] = "actions.preview_scroll_up",
                -- Copy full path
                ["<M-m>Y"] = "actions.copy_entry_path",
                -- Telescope grep from Oil's current directory
                ["<Leader>sg"] = {
                    callback = function()
                        local dir = require("oil").get_current_dir()
                        require("telescope").extensions.live_grep_args.live_grep_args({ search_dirs = { dir } })
                    end,
                    desc = "Grep in current dir",
                },
                -- Telescope find files from Oil's current directory
                ["<Leader>sf"] = {
                    callback = function()
                        local dir = require("oil").get_current_dir()
                        require("telescope.builtin").find_files({ cwd = dir })
                    end,
                    desc = "Find files in current dir",
                },
                -- Copy workspace (relative) path
                ["<M-m>y"] = {
                    callback = function()
                        local oil = require("oil")
                        local entry = oil.get_cursor_entry()

                        local dir = oil.get_current_dir()

                        if not entry or not dir then
                            return
                        end

                        local relpath = vim.fn.fnamemodify(dir, ":.")

                        vim.fn.setreg("+", relpath .. entry.name)
                        vim.fn.setreg("0",  relpath .. entry.name)
                    end,

                },
            },
        })
    end,
    keys =
    {
        { "<leader>fb", "<cmd>Oil<CR>", desc = "Open file browser" },
    },
}
