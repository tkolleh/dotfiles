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
  -- vim.api.nvim_command("colorscheme github_dark_tritanopia")
  -- vim.api.nvim_command("colorscheme tokyonight-moon")
  -- vim.api.nvim_command("colorscheme nightfox")

  -- Change teminal colors to dark
  require("tokyonight").load()
  vim.api.nvim_command("colorscheme tokyonight-night")
  return "tokyonight-night"
end

M.setLight = function()
  vim.api.nvim_command("highlight clear")
  vim.api.nvim_command("syntax reset")
  -- vim.api.nvim_command("colorscheme github_light_tritanopia")
  -- vim.api.nvim_command("colorscheme tokyonight-day")
  -- vim.api.nvim_command("colorscheme newpaper")
  -- vim.api.nvim_command("colorscheme cyberdream")

  -- Change teminal colors to dark
  require("nightfox").load()
  vim.api.nvim_command("colorscheme dayfox")
  return "dayfox"
end

M.is_background_dark = function()
  local bg = vim.api.nvim_get_option_value("background", {})
  local colorscheme = vim.g.colors_name

  -- Check if it's explicitly set to 'dark'.
  if bg == "dark" then
    return true
  end

  -- Check if it's explicitly set to 'light'.
  if bg == "light" then
    return false
  end

  -- If background is not set explicitly, check the color scheme
  if colorscheme then
    -- List of colorschemes known to be light
    local light_colorschemes = {
      "github_light_default",
      "github_light_high_contrast",
      "github_light_tritanopia",
    }

    for _, scheme in ipairs(light_colorschemes) do
      if colorscheme == scheme then
        return false
      end
    end
  end

  return false
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

return M
