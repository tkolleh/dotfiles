local M = {}

M.config = function()
  local dn = require('dark_notify')
  local dark_scheme = "tokyonight"
  dn.run({
    schemes = {
      -- This will just execute :set bg=dark or :set bg=light as soon as the system appearance changes
      -- using the dark-notify cmd on the terminal.
      dark  = {
        colorscheme = dark_scheme,
        background = "dark",
       },
      light = {
        colorscheme = "vscode",
        background = "light",
      }
    },
    onchange = function(mode)
      -- Called at startup and every time dark mode is switched,
      -- either via the OS, or because you manually set/toggled the mode.
      -- mode is either "light" or "dark"
      if dark_scheme == "tokyonight" then
        vim.g.tokyonight_style = mode == "dark" and "night" or "day"
        vim.g.tokyonight_colors = {
          -- Default is too dark for "night" style
          border = "orange"
        }
      elseif dark_scheme == "vscode" then
        vim.g.vscode_style = mode
        vim.g.vscode_italic_comment = 1
      end
    end,
  })
  dn.update()

  vim.api.nvim_set_keymap('n', '<F5>', [[<Cmd>lua require'dark_notify'.toggle()<CR>]], { noremap = true, silent = true })
end
return M
