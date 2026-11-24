local M = {}

-- Same grammar as vim's marks: m<symbol> toggles, ]<symbol> [<symbol> navigates, <leader>s<symbol> searches
-- marks ' (vim marks, buffer local for a-z, persisted):
--   m; : Toggle mark on current line (next free letter), ma..mz / mA..mZ : built-in
--   ]' [' : next/prev mark line in buffer (built-in), '<letter> : go to mark (built-in)
--   :delmarks (built-in, short :delm) : delete marks by name
--       :delm a      delete mark a           :delm a-d    delete marks a to d
--       :delm A      delete global mark A    :delm!       delete all a-z marks in buffer
-- bookmarks " (marks.nvim group 0, across buffers, not persisted):
--   m" : Toggle bookmark on current line
--   ]" [" : next/prev bookmark across buffers
-- ]' [' ]" [" are repeatable with ; (next) and , (prev), like the treesitter moves
-- <leader>s' <leader>s" : search marks / bookmarks, <C-c> deletes the selection
M.setup = function()
    require("marks").setup({
        default_mappings = false,
        force_write_shada = true,
        bookmark_0 = { sign = "\u{f02e}" },  -- nerd font bookmark (nf-fa-bookmark), escaped to survive editors; default sign is ')'
        mappings =
        {
            toggle = "m'",
        }
    })
    vim.keymap.set('n', 'm"', "<Plug>(Marks-toggle-bookmark0)", { desc = "Toggle bookmark (across buffers)" })

    -- go through treesitter-textobjects' repeatable move so ; and , repeat them (see configs/treesitter.lua)
    local make_repeatable_move = require("nvim-treesitter-textobjects.repeatable_move").make_repeatable_move
    local mark_move = make_repeatable_move(function(opts)
        vim.cmd("normal! " .. vim.v.count1 .. (opts.forward and "]'" or "['"))
    end)
    local bookmark_move = make_repeatable_move(function(opts)
        if opts.forward then require("marks").next_bookmark0() else require("marks").prev_bookmark0() end
    end)
    vim.keymap.set('n', "]'", function() mark_move({ forward = true }) end, { desc = "Next mark line (built-in, repeatable)" })
    vim.keymap.set('n', "['", function() mark_move({ forward = false }) end, { desc = "Prev mark line (built-in, repeatable)" })
    vim.keymap.set('n', ']"', function() bookmark_move({ forward = true }) end, { desc = "Next bookmark (across buffers)" })
    vim.keymap.set('n', '["', function() bookmark_move({ forward = false }) end, { desc = "Prev bookmark (across buffers)" })

    -- <C-c> deletes the selected mark(s)/bookmark(s) from the pickers (same key as buffer deletion)
    vim.keymap.set('n', "<leader>s'", function()
        require("telescope.builtin").marks({
            attach_mappings = function(_, map)
                map({ 'i', 'n' }, "<C-c>", require("telescope.actions").delete_mark)
                return true
            end,
        })
    end, { desc = "Search marks" })

    -- bookmarks are not vim marks (not listed by Telescope marks): go through the quickfix list
    vim.keymap.set('n', '<leader>s"', function()
        vim.cmd("BookmarksQFListAll")
        vim.cmd("cclose")
        if #vim.fn.getqflist() == 0 then
            vim.notify("No bookmarks", vim.log.levels.INFO)
            return
        end
        require("telescope.builtin").quickfix({
            attach_mappings = function(prompt_bufnr, map)
                map({ 'i', 'n' }, "<C-c>", function()
                    local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                    picker:delete_selection(function(selection)
                        local bufnr = selection.bufnr or vim.fn.bufnr(selection.filename)
                        require("marks").bookmark_state:delete_mark(0, bufnr, selection.lnum)
                        return true
                    end)
                end)
                return true
            end,
        })
    end, { desc = "Search bookmarks" })
end

return M
