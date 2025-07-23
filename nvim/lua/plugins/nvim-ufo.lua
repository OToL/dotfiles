-- Better code folding
return {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
        require("ufo").setup({})
    end,
    -- zo: Open fold under cursor
    -- zO: Open all folds
    -- zc: Close fold under cursor
    -- zf: fold object
    -- za: Toggle fold in current scope/block
    -- zA: Toggle fold and sub-folds in current scope/block
    -- zk: Preview fold under cursor
    -- zC: close all folds
    keys =
    {
        { "zO", "<cmd>lua require('ufo').openAllFolds()<CR>", desc = "Open all folds" },
        { "zC", "<cmd>lua require('ufo').closeAllFolds()<CR>", desc = "Close all folds" },
        { "zk", "<cmd>lua require('ufo').peekFoldedLinesUnderCursor()<CR>", desc = "Preview folded block" },
    },
}
