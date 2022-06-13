local M = {}

M.config = function ()
  require('spectre').setup({
    open_cmd = 'new',
  })
end

return M
