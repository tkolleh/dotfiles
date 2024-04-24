-- Neovide GUI configuration
-- Includes keymappings / keybindings [view all the defaults by pressing <leader>Lk]
--
local M = {}
M.config = function()
  vim.opt.guifont = "JetBrainsMono Nerd Font,JetBrainsMono\\ Nerd\\ Font\\ Mono,JetBrainsMono\\ NFM:h13"
  vim.g.remember_window_size = true
  vim.g.remember_window_position = true

  local function toggle_transparency()
    if vim.g.neovide_transparency == 1.0 then
      vim.cmd "let g:neovide_transparency=0.8"
    else
      vim.cmd "let g:neovide_transparency=1.0"
    end
  end

  local function toggle_fullscreen()
    if vim.g.neovide_fullscreen == false then
      vim.cmd "let g:neovide_fullscreen=v:true"
    else
      vim.cmd "let g:neovide_fullscreen=v:false"
    end
  end

  lvim.keys.normal_mode["<F11>"] = toggle_fullscreen
  lvim.keys.normal_mode["<F10>"] = toggle_transparency
  -- copy
  lvim.keys.visual_mode["<D-c>"] = '"+y'
  -- paste
  lvim.keys.normal_mode["<D-v>"] = '"+p'
  lvim.keys.insert_mode["<D-v> <Esc>"] = '"+p'
end

return M
