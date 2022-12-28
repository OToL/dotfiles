local status_ok, surround = pcall(require, "nvim-surround")
if not status_ok then
    return
end

-- basic usage:
--    * ys<object><char>: sarround object with <char>
--    * ds<object><char>: delete <char> surrounding the object
--    * cs<old_char><new_char>: replace surrounding <old_char> with <new_char>
-- funky usage:
--            Old text                    Command              New text
----------------------------------------------------------------------------------
--       remove <b>HTML t*ags</b>           dst             remove HTML tags
--       <b>or tag* types</b>               csth1<CR>       <h1>or tag types</h1>
--       delete(functi*on calls)            dsf             function calls
surround.setup({
    -- Configuration here, or leave empty to use defaults
})
