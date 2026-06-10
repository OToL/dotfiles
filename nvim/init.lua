require('vim._core.ui2').enable()

require("options")
require("commands")
require("keymappings")
require("diagnostics")
require("pack")

local utils = require("utils")
local pipe_path = utils.get_nvim_pipe_path()

-- pcall (protected call) allows silent failure if the pipe is already taken
if vim.fn.has('win32') == 1 or vim.fn.has('unix') == 1 then
    pcall(vim.fn.serverstart, pipe_path)
end

