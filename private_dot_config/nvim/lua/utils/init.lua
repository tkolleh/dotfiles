--
-- Utility functions
--
local M = {}

M.is_nil_or_empty = function(value)
  return value == nil or value == ""
end

M.use_if_defined = function(val, fallback)
return val ~= nil and val or fallback
end

M.setDark = function()
  vim.api.nvim_command("highlight clear")
  vim.api.nvim_command("syntax reset")
  -- vim.api.nvim_command("colorscheme github_dark_colorblind")
  -- vim.api.nvim_command("colorscheme tokyonight-moon")
  -- vim.api.nvim_command("colorscheme nightfox")
  -- vim.api.nvim_command("colorscheme tokyonight-night")

  vim.api.nvim_command("colorscheme catppuccin-mocha")
  return "catppuccin-mocha"
end

M.setLight = function()
  vim.api.nvim_command("highlight clear")
  vim.api.nvim_command("syntax reset")
  -- vim.api.nvim_command("colorscheme github_light_colorblind")
  -- vim.api.nvim_command("colorscheme tokyonight-day")
  -- vim.api.nvim_command("colorscheme dayfox")

  -- require("catppuccin").load()
  vim.api.nvim_command("colorscheme catppuccin-latte")
  return "catppuccin-latte"
end

M.is_background_dark = function()
  local bg = vim.api.nvim_get_option_value("background", {})
  if bg == "dark" then
    return true
  else
    return false
  end
end

M.apply_auto_background_theme = function()
  if M.is_background_dark() then
    M.setDark()
  else
    M.setLight()
  end
end

---Cycle through different diagnostic display modes or override the current display modes.
---Cycle from:
--- * nothing displayed
--- * single diagnostic at the end of the line (`virtual_text`)
--- * full diagnostics using virtual text (`virtual_lines`)
---@param override { virtual_text: boolean, virtual_lines: boolean }
---@return nil
M.cycle_diagnostics_display = function(override)
  -- check if text and lines are not (explicitly) equal to false ortherwise true
  local text = vim.diagnostic.config().virtual_text ~= false
  local lines = vim.diagnostic.config().virtual_lines ~= false

  -- Text -> Lines transition
  if text then
    text = false
    lines = true
  -- Lines -> Nothing transition
  elseif lines then
    text = false
    lines = false
  -- Nothing -> Text transition
  else
    text = true
    lines = false
  end
  vim.diagnostic.config(
    vim.tbl_deep_extend("keep", override or {}, { virtual_text = text, virtual_lines = lines }
  )
)
end

M.compile_code = function()
  local filetype = vim.bo.filetype:lower()
  local compiler_lookup = {}

  local metals_filetypes = { "scala", "sbt" }
  compiler_lookup[metals_filetypes] = function()
    require("metals").compile_cascade()
  end

  local fn = compiler_lookup[filetype]
  if fn ~= nil then
    fn()
  else
    print("No compiler configured for filetype: " .. filetype)
  end
end

return M
