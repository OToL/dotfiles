local M = {}

local uv = vim.loop
local path_sep = uv.os_uname().version:match "Windows" and "\\" or "/"

-- Execute a system command line
-- @return command line output as string
function M.execute_command(command)
    local handle = io.popen(command)
    local result

    if handle ~= nil then
        result = handle:read("*a")
        handle:close()
    end

    return result
end

-- Get the first location of a program from its name
-- @return path to the program on nil
function M.find_program_path(program_name, ignore_system_path)
    local command
    local is_windows = string.match(vim.loop.os_uname().sysname, "^Windows")

    if (is_windows) then
        command = "where " .. program_name
    else -- Unix-like platforms (Linux, macOS)
        command = "which " .. program_name
    end

    local result = M.execute_command(command)
    local path_pattern = "[^\r\n]+"
    local path = ""

    if is_windows and ignore_system_path then
        for path_val in result:gmatch(path_pattern) do
            if string.find(path_val, "WindowsApps") == nil then
                path = path_val
                break
            end
        end
    else
        for path_val in result:gmatch(path_pattern) do
            path = path_val
            break
        end
    end

    if path ~= "" then
        return path
    else
        return nil
    end
end

-- Join path segments that were passed as input
-- @return string
function M.joinPaths(...)
    local result = table.concat({ ... }, path_sep)
    return result
end

-- Checks whether a given path exists and is a file.
-- @param path (string) path to check
-- @returns (bool)
function M.isFile(path)
    local stat = uv.fs_stat(path)
    return stat and stat.type == "file" or false
end

-- Checks whether a given path exists and is a directory
-- @param path (string) path to check
-- @returns (bool)
function M.isDirectory(path)
    local stat = uv.fs_stat(path)
    return stat and stat.type == "directory" or false
end

-- Write data to a file
-- @param path string can be full or relative to `cwd`
-- @param txt string|table text to be written, uses `vim.inspect` internally for tables
-- @param flag string used to determine access mode, common flags: "w" for `overwrite` or "a" for `append`
function M.writeFile(path, txt, flag)
    local data = type(txt) == "string" and txt or vim.inspect(txt)
    uv.fs_open(path, flag, 438, function(open_err, fd)
        assert(not open_err, open_err)
        uv.fs_write(fd, data, -1, function(write_err)
            assert(not write_err, write_err)
            uv.fs_close(fd, function(close_err)
                assert(not close_err, close_err)
            end)
        end)
    end)
end

-- Copies a file or directory recursively
-- @param source string
-- @param destination string
function M.fsCopy(source, destination)
    local source_stats = assert(vim.loop.fs_stat(source))

    if source_stats.type == "file" then
        assert(vim.loop.fs_copyfile(source, destination))
        return
    elseif source_stats.type == "directory" then
        local handle = assert(vim.loop.fs_scandir(source))

        assert(vim.loop.fs_mkdir(destination, source_stats.mode))

        while true do
            local name = vim.loop.fs_scandir_next(handle)
            if not name then
                break
            end

            M.fs_copy(M.join_paths(source, name), M.join_paths(destination, name))
        end
    end
end

function M.make()
    local lines = { "" }
    local winnr = vim.fn.win_getid()
    local bufnr = vim.api.nvim_win_get_buf(winnr)

    local makeprg = vim.api.nvim_buf_get_option(bufnr, "makeprg")
    if not makeprg then return end

    local cmd = vim.fn.expandcmd(makeprg)

    local function on_event(job_id, data, event)
        if event == "stdout" or event == "stderr" then
            if data then
                vim.list_extend(lines, data)
            end
        end

        if event == "exit" then
            vim.fn.setqflist({}, " ", {
                title = cmd,
                lines = lines,
                efm = vim.api.nvim_buf_get_option(bufnr, "errorformat")
            })
            vim.api.nvim_command("doautocmd QuickFixCmdPost")
        end
    end

    local job_id =
        vim.fn.jobstart(
            cmd,
            {
                on_stderr = on_event,
                on_stdout = on_event,
                on_exit = on_event,
                stdout_buffered = true,
                stderr_buffered = true,
            }
        )
end

M.toggle_qf = function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd "cclose"
    return
  end
  --if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd "copen"
  --end
end

M.close_floating_windows = function()
  local closed_windows = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then  -- is_floating_window?                                    
      vim.api.nvim_win_close(win, false)  -- do not force
      table.insert(closed_windows, win)
    end
  end
  print(string.format('Closed %d windows: %s', #closed_windows, vim.inspect(closed_windows)))
end


M.close_floating_windows = function()
  local closed_windows = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then  -- is_floating_window?                                    
      vim.api.nvim_win_close(win, false)  -- do not force
      table.insert(closed_windows, win)
    end
  end
  print(string.format('Closed %d floating windows: %s', #closed_windows, vim.inspect(closed_windows)))
end

return M
