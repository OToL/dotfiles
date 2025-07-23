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
return {
  "kylechui/nvim-surround",
  event = { "BufReadPre", "BufNewFile" },
  config = true,
}
