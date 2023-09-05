local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

configs.setup({
    -- specify "all" to intall all supported languages
    ensure_installed = { "c", "cpp", "cmake", "markdown", "markdown_inline", "python", "bash", "c_sharp", "html", "json",
        "lua", "yaml" },
    ignore_install = { "" },
    highlight = {
        enable = true,
        disable = { "css" },
    },
    autopairs = {
        enable = true,
    },
    indent = { enable = true, disable = { "python", "css", "cpp" } },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<c-backspace>',
        },
    },
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                -- =: assignment
                ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment region" },
                ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment region" },

                -- i: conditional
                ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional region" },
                ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional region" },

                -- l: loop
                ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop region" },
                ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop region" },

                -- b: block
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",

                -- a: argument
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",

                -- f: function
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",

                -- c: class
                ["ac"] = "@class.outer",
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    [']m'] = '@function.outer',
                    [']]'] = '@class.outer',
                },
                goto_next_end = {
                    [']M'] = '@function.outer',
                    [']['] = '@class.outer',
                },
                goto_previous_start = {
                    ['[m'] = '@function.outer',
                    ['[['] = '@class.outer',
                },
                goto_previous_end = {
                    ['[M'] = '@function.outer',
                    ['[]'] = '@class.outer',
                },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V',  -- linewise
                ['@class.outer'] = '<c-v>', -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true of false
            include_surrounding_whitespace = true,
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
    },
})

local ctx_status_ok, ctx_configs = pcall(require, "treesitter-context")
if not ctx_status_ok then
    return
end

ctx_configs.setup {
    enable = true,
    max_lines = 1,
    trim_scope = "inner",
}