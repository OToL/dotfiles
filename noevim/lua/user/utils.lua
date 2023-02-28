local M = {}

local uv = vim.loop
local path_sep = uv.os_uname().version:match "Windows" and "\\" or "/"

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

return M
