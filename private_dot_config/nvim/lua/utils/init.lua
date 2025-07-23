--
-- Utility functions
--
local M = {}

M.setDark = function()
  vim.api.nvim_command("highlight clear")
  vim.api.nvim_command("syntax reset")
  -- vim.api.nvim_command("colorscheme github_dark_tritanopia")
  vim.api.nvim_command("colorscheme tokyonight-moon")
  -- Change teminal colors to dark
  vim.fn.jobstart("set_bat_theme 1", { detach = true })
end

M.setLight = function()
  vim.api.nvim_command("highlight clear")
  vim.api.nvim_command("syntax reset")
  -- vim.api.nvim_command("colorscheme github_light_tritanopia")
  -- vim.api.nvim_command("colorscheme tokyonight-day")
  -- vim.api.nvim_command("colorscheme newpaper")
  -- vim.api.nvim_command("colorscheme cyberdream")
  vim.api.nvim_command("colorscheme dayfox")
  vim.fn.jobstart("set_bat_theme 0", { detach = true })
end

M.is_background_dark = function()
  local bg = vim.api.nvim_get_option_value("bg", {})
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

M.cycle_diagnostics_display = function()
  -- Cycle from:
  -- * nothing displayed
  -- * single diagnostic at the end of the line (`virtual_text`)
  -- * full diagnostics using virtual text (`virtual_lines`)

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

  vim.diagnostic.config({
    virtual_text = text,
    virtual_lines = lines,
  })
end

return M
