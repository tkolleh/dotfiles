local M = {}

M.config = function()
  local dn = require('dark_notify')
  dn.run({
    schemes = {
      -- you can use a different colorscheme for each
      dark  = {
        colorscheme = "tokyonight",
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
      if mode == "dark" then
        lvim.colorscheme = "tokyonight"
        vim.g.tokyonight_style = "night"
      else
        lvim.colorscheme = "vscode"
        vim.g.vscode_style = mode
        vim.g.vscode_italic_comment = 1
        vim.o.background = mode
      end
    end,
  })
  dn.update()

  vim.api.nvim_set_keymap('n', '<F5>', [[<Cmd>lua require'dark_notify'.toggle()<CR>]], { noremap = true, silent = true })
end
return M
