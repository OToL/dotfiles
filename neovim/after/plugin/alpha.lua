local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")
-- https://patorjk.com/software/taag/#p=display&f=Graffiti&t=OTol
dashboard.section.header.val = {
"          .                                                      .",
"        .n                   .                 .                  n.",
"  .   .dP                  dP                   9b                 9b.    .",
" 4    qXb         .       dX                     Xb       .        dXp     t",
"dX.    9Xb      .dXb    __                         __    dXb.     dXP     .Xb",
"9XXb._       _.dXXXXb dXXXXbo.                 .odXXXXb dXXXXb._       _.dXXP",
" 9XXXXXXXXXXXXXXXXXXXVXXXXXXXXOo.           .oOXXXXXXXXVXXXXXXXXXXXXXXXXXXXP",
"  `9XXXXXXXXXXXXXXXXXXXXX'~   ~`OOO8b   d8OOO'~   ~`XXXXXXXXXXXXXXXXXXXXXP'",
"    `9XXXXXXXXXXXP' `9XX'   DIE    `98v8P'  HUMAN   `XXP' `9XXXXXXXXXXXP'",
"        ~~~~~~~       9X.          .db|db.          .XP       ~~~~~~~",
"                        )b.  .dbo.dP'`v'`9b.odb.  .dX(",
"                      ,dXXXXXXXXXXXb     dXXXXXXXXXXXb.",
"                     dXXXXXXXXXXXP'   .   `9XXXXXXXXXXXb",
"                    dXXXXXXXXXXXXb   d|b   dXXXXXXXXXXXXb",
"                    9XXb'   `XXXXXb.dX|Xb.dXXXXX'   `dXXP",
"                     `'      9XXXXXX(   )XXXXXXP      `'",
"                              XXXX X.`v'.X XXXX",
"                              XP^X'`b   d'`X^XX",
"                              X. 9  `   '  P )X",
"                              `b  `       '  d'",
"                               `             '"
}



dashboard.section.buttons.val = {
--	dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
	dashboard.button("w", "  Find workspace", ":Telescope workspaces <CR>"),
	dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
	dashboard.button("c", "  Configuration", ":e ~/appdata/Local/nvim/init.lua <CR>"),
	dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

local function footer()
-- NOTE: requires the fortune-mod package to work
	-- local handle = io.popen("fortune")
	-- local fortune = handle:read("*a")
	-- handle:close()
	-- return fortune
    return ""
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])

alpha.setup(dashboard.opts)
