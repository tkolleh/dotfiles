local M = {}

M.config = function()
  local dn = require('dark_notify')
  local scheme = "lunar"
  dn.run({
    schemes = {
      -- you can use a different colorscheme for each
      dark  = {
        colorscheme = scheme,
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
      if scheme == "tokyonight" then
        vim.g.tokyonight_style = mode == "dark" and "night" or "day"
        vim.g.tokyonight_colors = {
          -- Default is too dark for "night" style
          border = "orange"
        }
      elseif scheme == "vscode" then
        vim.g.vscode_style = mode
        vim.g.vscode_italic_comment = 1
      end

      -- Color scheme must be set last
      vim.o.background = mode
      lvim.background = mode
      lvim.colorscheme = scheme
    end,
  })
  dn.update()

  vim.api.nvim_set_keymap('n', '<F5>', [[<Cmd>lua require'dark_notify'.toggle()<CR>]], { noremap = true, silent = true })
end
return M
