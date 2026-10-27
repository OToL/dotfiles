local M = {}

-- fzf-lua is only used for file search: the file list is piped straight from fd into the fzf binary,
-- which avoids telescope's per-line Lua processing on large trees (UE ~340k files).
-- Everything else stays on telescope.
M.setup = function()

    require("fzf-lua").setup({
        keymap = {
            -- neovim :tmap mappings, used by the builtin previewer
            builtin = {
                true, -- inherit defaults
                ["<C-u>"] = "preview-page-up",
                ["<C-d>"] = "preview-page-down",
            },
            -- fzf --bind options
            fzf = {
                true, -- inherit defaults
                ["alt-w"] = "abort",
            },
        },
        files = {
            -- --no-ignore-vcs: skip .gitignore but respect the project's .ignore file
            fd_opts    = "--color=never --type f --hidden --no-ignore-vcs",
            -- no per-entry Lua processing, fd output goes to fzf as is
            file_icons = false,
            git_icons  = false,
        },
    })

end

return M
