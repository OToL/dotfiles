local status_ok, bufferline = pcall(require, "bufdel")
if not status_ok then
  return
end

require('bufdel').setup{}
