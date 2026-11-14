local M = {}

-- copies the entry under cursor, or every entry in a visual selection (one per line),
-- using a fnamemodify() modifier (same keys as the buffer ones in keymappings.lua)
local function copy_entry(modifier)
    return function()
        local oil = require("oil")
        local dir = oil.get_current_dir()
        if not dir then return end

        local first, last = vim.fn.line("."), vim.fn.line(".")
        if vim.fn.mode():match("[vV\22]") then
            first, last = vim.fn.line("v"), vim.fn.line(".")
            if first > last then first, last = last, first end
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end

        local values, seen = {}, {}
        for lnum = first, last do
            local entry = oil.get_entry_on_line(0, lnum)
            if entry then
                local value = vim.fn.fnamemodify(dir .. entry.name, modifier)
                if not seen[value] then   -- e.g. `yd` gives the same dir for every entry
                    seen[value] = true
                    table.insert(values, value)
                end
            end
        end
        if #values == 0 then return end

        local text = table.concat(values, "\n")
        vim.fn.setreg("+", text)
        vim.fn.setreg("0", text)
    end
end

M.setup = function()

    require("oil").setup({
        -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
        delete_to_trash = true,
        -- Set to false to disable all of the above keymaps
        use_default_keymaps = true,
        -- Set to true to watch the filesystem for changes and reload oil
        experimental_watch_for_changes = true,
        -- `: set the current oild dir as workspace root dir (e.g. cd)
        keymaps = {
            ["g?"] = "actions.show_help",
            ["gs"] = "actions.change_sort",
            ["gx"] = "actions.open_external",
            ["g."] = "actions.toggle_hidden",
            ["g\\"] = "actions.toggle_trash",
            ["gh"] = "actions.open_cwd",
            ["g~"] = {
                callback = function() require("oil").open(vim.fn.expand("~")) end,
                desc = "Go to home directory",
            },
            ["<CR>"] = "actions.select",
            ["<BS>"] = "actions.parent",
            ["<C-v>"] = "actions.select_vsplit",
            ["<C-s>"] = "actions.select_split",
            ["<C-t>"] = "actions.select_tab",
            ["<C-p>"] = "actions.preview",
            ["<C-r>"] = "actions.refresh",
            ["<M-w>"] = "actions.close",
            ["J"] = "actions.preview_scroll_down",
            ["K"] = "actions.preview_scroll_up",
            -- Telescope grep from Oil's current directory
            ["<Leader>sg"] = {
                callback = function()
                    local dir = require("oil").get_current_dir()
                    require("telescope").extensions.live_grep_args.live_grep_args({ search_dirs = { dir } })
                end,
                desc = "Grep in current dir",
            },
            -- Find files from Oil's current directory
            ["<Leader>sf"] = {
                callback = function()
                    local dir = require("oil").get_current_dir()
                    require("fzf-lua").files({ cwd = dir })
                end,
                desc = "Find files in current dir",
            },
            -- Copy entry name / full path / workspace (relative) path / directory
            ["<leader>yf"] = { callback = copy_entry(":t"),   mode = { "n", "x" }, desc = "Copy entry name(s)" },
            ["<leader>yp"] = { callback = copy_entry(":p"),   mode = { "n", "x" }, desc = "Copy entry full path(s)" },
            ["<leader>yr"] = { callback = copy_entry(":."),   mode = { "n", "x" }, desc = "Copy entry relative path(s)" },
            ["<leader>yd"] = { callback = copy_entry(":p:h"), mode = { "n", "x" }, desc = "Copy entry directory" },
        },
    })

    vim.keymap.set("n", "<leader>fb", "<cmd>Oil<CR>", { desc = "Open File Browser" })

end

return M
