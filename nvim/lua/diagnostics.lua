local diag_severity = vim.diagnostic.severity

vim.diagnostic.config({
    virtual_text = true,

    signs = {
        text = {
            [diag_severity.ERROR] = " ",
            [diag_severity.WARN] = " ",
            [diag_severity.INFO] = " ",
            [diag_severity.HINT] = "󰠠 "
        }
    }

    -- Only show virtual line diagnostics for the current cursor line
    -- virtual_lines = {
    --  current_line = true,
    -- }
})

