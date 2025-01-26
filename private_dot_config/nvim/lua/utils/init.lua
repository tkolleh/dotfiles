--
-- Utility functions
--

local M = {}

M.setDark = function()
  vim.api.nvim_set_option_value("background", "dark", {})
  vim.cmd("colorscheme tokyonight-moon")
end

M.setLight = function()
  vim.api.nvim_set_option_value("background", "light", {})
  vim.cmd("colorscheme github_light_high_contrast")
end

M.is_background_dark = function()
  local bg = vim.opt.background:get()
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

return M
