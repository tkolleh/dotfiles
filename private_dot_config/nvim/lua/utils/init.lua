--
-- Utility functions
--
local M = {}

M.is_nil_or_empty = function(value)
  return value == nil or value == ""
end

---@return boolean
M.is_gui = function()
  return vim.g.gui_vimr == 1
end

M.use_if_defined = function(val, fallback)
  return val ~= nil and val or fallback
end

-- Dark  : (github_dark_colorblind | tokyonight-moon | nightfox | carbonfox | tokyonight-night)
M.dark_theme = "nightfox"

-- Light : (github_light_colorblind | tokyonight-day | dayfox)
M.light_theme = "dayfox"

M.is_background_dark = function()
  -- Relies on Neovim's DEC mode 2031 terminal query (supported by Ghostty)
  -- to have already set vim.o.background to 'dark' or 'light'.
  return string.lower(vim.o.background) == "dark"
end

M.apply_auto_background_theme = function()
  local is_dark = M.is_background_dark()
  local theme = is_dark and M.dark_theme or M.light_theme
  local _colorscheme = vim.g.colors_name or "none"

  if string.lower(_colorscheme) ~= string.lower(theme) then
    local ok, err = pcall(vim.cmd.colorscheme, theme)
    if not ok then
      vim.notify("Theme change failed: " .. tostring(err), vim.log.levels.WARN)
      return theme
    end
    -- Trigger ColorScheme event to update diff highlights
    vim.api.nvim_exec_autocmds("ColorScheme", { pattern = theme })
  end
  return theme
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
  vim.diagnostic.config(vim.tbl_deep_extend("keep", override or {}, { virtual_text = text, virtual_lines = lines }))
end

M.compile_code = function()
  local filetype = vim.bo.filetype:lower()
  local compiler_lookup = {}

  compiler_lookup["scala"] = function()
    require("metals").compile_cascade()
  end
  compiler_lookup["sbt"] = function()
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
