return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local select = require("nvim-treesitter-textobjects.select")
        local swap = require("nvim-treesitter-textobjects.swap")
        local move = require("nvim-treesitter-textobjects.move")
        local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

        require("nvim-treesitter-textobjects").setup({
            select = {
                lookahead = true,
                include_surrounding_whitespace = true,
            },
            move = {
                set_jumps = true,
            },
        })

        -- Helper to create select keymaps
        local function sel(lhs, query, desc)
            vim.keymap.set({ "x", "o" }, lhs, function()
                select.select_textobject(query, "textobjects")
            end, { desc = desc })
        end

        -- Select keymaps
        sel("a=", "@assignment.outer", "Select outer part of an assignment")
        sel("i=", "@assignment.inner", "Select inner part of an assignment")

        sel("a:", "@property.outer", "Select outer part of an object property")
        sel("i:", "@property.inner", "Select inner part of an object property")
        sel("r:", "@property.rhs", "Select right part of an object property")

        sel("aa", "@parameter.outer", "Select outer part of a parameter/argument")
        sel("ia", "@parameter.inner", "Select inner part of a parameter/argument")

        sel("ai", "@conditional.outer", "Select outer part of a conditional")
        sel("ii", "@conditional.inner", "Select inner part of a conditional")

        sel("al", "@loop.outer", "Select outer part of a loop")
        sel("il", "@loop.inner", "Select inner part of a loop")

        sel("af", "@call.outer", "Select outer part of a function call")
        sel("if", "@call.inner", "Select inner part of a function call")

        sel("am", "@function.outer", "Select outer part of a method/function definition")
        sel("im", "@function.inner", "Select inner part of a method/function definition")

        sel("ac", "@class.outer", "Select outer part of a class")
        sel("ic", "@class.inner", "Select inner part of a class")

        -- Swap keymaps
        vim.keymap.set("n", "<leader>na", function() swap.swap_next("@parameter.inner") end, { desc = "Swap parameter with next" })
        vim.keymap.set("n", "<leader>n:", function() swap.swap_next("@property.outer") end, { desc = "Swap property with next" })
        vim.keymap.set("n", "<leader>nm", function() swap.swap_next("@function.outer") end, { desc = "Swap function with next" })
        vim.keymap.set("n", "<leader>pa", function() swap.swap_previous("@parameter.inner") end, { desc = "Swap parameter with prev" })
        vim.keymap.set("n", "<leader>p:", function() swap.swap_previous("@property.outer") end, { desc = "Swap property with prev" })
        vim.keymap.set("n", "<leader>pm", function() swap.swap_previous("@function.outer") end, { desc = "Swap function with previous" })

        -- Move keymaps - goto next start
        vim.keymap.set({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.inner", "textobjects") end, { desc = "Next argument" })
        vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@call.outer", "textobjects") end, { desc = "Next function call start" })
        vim.keymap.set({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next method/function def start" })
        vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next class start" })
        vim.keymap.set({ "n", "x", "o" }, "]i", function() move.goto_next_start("@conditional.outer", "textobjects") end, { desc = "Next conditional start" })
        vim.keymap.set({ "n", "x", "o" }, "]l", function() move.goto_next_start("@loop.outer", "textobjects") end, { desc = "Next loop start" })
        vim.keymap.set({ "n", "x", "o" }, "]s", function() move.goto_next_start("@scope", "locals") end, { desc = "Next scope" })
        vim.keymap.set({ "n", "x", "o" }, "]z", function() move.goto_next_start("@fold", "folds") end, { desc = "Next fold" })

        -- Move keymaps - goto next end
        vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@call.outer", "textobjects") end, { desc = "Next function call end" })
        vim.keymap.set({ "n", "x", "o" }, "]M", function() move.goto_next_end("@function.outer", "textobjects") end, { desc = "Next method/function def end" })
        vim.keymap.set({ "n", "x", "o" }, "]C", function() move.goto_next_end("@class.outer", "textobjects") end, { desc = "Next class end" })
        vim.keymap.set({ "n", "x", "o" }, "]I", function() move.goto_next_end("@conditional.outer", "textobjects") end, { desc = "Next conditional end" })
        vim.keymap.set({ "n", "x", "o" }, "]L", function() move.goto_next_end("@loop.outer", "textobjects") end, { desc = "Next loop end" })

        -- Move keymaps - goto previous start
        vim.keymap.set({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.inner", "textobjects") end, { desc = "Prev argument" })
        vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@call.outer", "textobjects") end, { desc = "Prev function call start" })
        vim.keymap.set({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Prev method/function def start" })
        vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Prev class start" })
        vim.keymap.set({ "n", "x", "o" }, "[i", function() move.goto_previous_start("@conditional.outer", "textobjects") end, { desc = "Prev conditional start" })
        vim.keymap.set({ "n", "x", "o" }, "[l", function() move.goto_previous_start("@loop.outer", "textobjects") end, { desc = "Prev loop start" })

        -- Move keymaps - goto previous end
        vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@call.outer", "textobjects") end, { desc = "Prev function call end" })
        vim.keymap.set({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@function.outer", "textobjects") end, { desc = "Prev method/function def end" })
        vim.keymap.set({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", "textobjects") end, { desc = "Prev class end" })
        vim.keymap.set({ "n", "x", "o" }, "[I", function() move.goto_previous_end("@conditional.outer", "textobjects") end, { desc = "Prev conditional end" })
        vim.keymap.set({ "n", "x", "o" }, "[L", function() move.goto_previous_end("@loop.outer", "textobjects") end, { desc = "Prev loop end" })

        -- Repeatable move: ; goes to the direction you were moving
        vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
        vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

        -- Make builtin f, F, t, T also repeatable with ; and ,
        vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    end,
}
