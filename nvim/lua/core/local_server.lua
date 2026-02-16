-- Determine path based on OS
local function get_pipe_path()
    if vim.fn.has('win32') == 1 then
        return [[\\.\pipe\nvim-main-instance]]
    else
        -- Use XDG_RUNTIME_DIR if available, else fallback to /tmp
        local runtime_dir = os.getenv("XDG_RUNTIME_DIR") or "/tmp"
        return runtime_dir .. "/nvim-main.sock"
    end
end

local pipe_path = get_pipe_path()

-- pcall (protected call) allows silent failure if the pipe is already taken
if vim.fn.has('win32') == 1 or vim.fn.has('unix') == 1 then
    pcall(vim.fn.serverstart, pipe_path)
end

