local M = {}

-- Toggle soft wrap
M.is_wrapped = function()
  return vim.o.wrap
end
M.enable_wrap = function()
  vim.o.wrap = true
end
M.disable_wrap = function()
  vim.o.wrap = false
end
M.toggle_wrap = function()
  vim.o.wrap = not vim.o.wrap
end

-- Toggle background mode
M.toggle_background = function()
  require("utils").apply_auto_background_theme()
end

-- Togle relative number
M.is_relativenumber = function()
  return vim.o.relativenumber
end
M.enable_relativenumber = function()
  vim.o.relativenumber = true
end
M.disable_relativenumber = function()
  vim.o.relativenumber = false
end
M.toggle_relativenumber = function()
  vim.o.relativenumber = not vim.o.relativenumber
end

-- Toggle spell check
M.is_spellchecked = function()
  return vim.o.spell
end
M.enable_spell = function()
  vim.o.spell = true
end
M.disable_spell = function()
  vim.o.spell = false
end
M.toggle_spell = function()
  vim.o.spell = not vim.o.spell
end

return M
