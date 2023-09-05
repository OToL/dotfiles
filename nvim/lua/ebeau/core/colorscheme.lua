status, _ = pcall(vim.cmd, "colorscheme nightfly")
if not status then
    print("failed to locate nightfly colorscheme")
    return
end
