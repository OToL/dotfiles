-- Displays home page
return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local icons = require("ebeau.core.icons")
        local alpha = require("alpha")
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
            dashboard.button("w", icons.ui.Folder .. " Find workspace", ":Telescope workspaces <CR>"),
            dashboard.button("f", icons.ui.Search .. " Find file", ":Telescope find_files <CR>"),
            dashboard.button("e", icons.ui.NewFile .. " New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("r", icons.ui.History .. " Recently used files", ":Telescope oldfiles <CR>"),
            dashboard.button("c", icons.ui.Gear .. " Configuration", ":e ~/.config/nvim/init.lua <CR>"),
            dashboard.button("q", icons.ui.SignOut .. " Quit Neovim", ":qa<CR>"),
        }

        dashboard.section.footer.opts.hl = "Type"
        dashboard.section.header.opts.hl = "Include"
        dashboard.section.buttons.opts.hl = "Keyword"

        dashboard.opts.opts.noautocmd = true

        alpha.setup(dashboard.opts)

        -- Disable folding on alpha buffer
        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
}


