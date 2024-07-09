-- Deprecated use fd and sad with fzf instead
local M = {}

M.config = function ()
  require('spectre').setup({
    open_cmd = 'new',
  })
end

return M
