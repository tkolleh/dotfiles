local M = {}

M.config = function()
  require('dark_notify').run({
    schemes = {
      -- you can use a different colorscheme for each
      dark  = {
        colorscheme = "vscode",
        background = "dark",
       },
      light = {
        colorscheme = "vscode",
        background = "light",
      }
    },
    onchange = function(mode)
      -- optional, you can configure your own things to react to changes.
      -- this is called at startup and every time dark mode is switched,
      -- either via the OS, or because you manually set/toggled the mode.
      -- mode is either "light" or "dark"

      lvim.colorscheme = "vscode"
      vim.g.vscode_style = mode
      vim.g.vscode_italic_comment = 1
      vim.o.background = mode
    end,
  })
end
return M
