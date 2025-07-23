-- Animated text used e.g. when lsp is processing the buffer 
return {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = function()
        require("fidget").setup()
    end,
}

