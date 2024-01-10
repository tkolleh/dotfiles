local h = require("user.helpers")

local function getActions()
  local status_ok, actions = pcall(require, "telescope.actions")
  if not status_ok then
    vim.notify("telescope.actions not found", vim.log.levels.ERROR)
    return {}
  end
  return actions
end

local actions = getActions()

local function setup_defaults()
  lvim.builtin.telescope.defaults.file_ignore_patterns = { "target", "node_modules", "parser.c", "out", "%.min.js" }
  lvim.builtin.telescope.defaults.prompt_prefix = "❯"
  lvim.builtin.telescope.defaults.selection_caret = " "
  lvim.builtin.telescope.defaults.sorting_strategy = "ascending"
  lvim.builtin.telescope.defaults.layout_strategy = "horizontal"
  lvim.builtin.telescope.defaults.layout_config = {
    height = 0.8,
    width = 0.7
  }
  lvim.builtin.telescope.defaults.path_display = { "smart" }
  lvim.builtin.telescope.defaults.wrap_results = false
  lvim.builtin.telescope.defaults.dynamic_preview_title = true
  -- lvim.builtin.telescope.defaults.theme = "dropdown"
  lvim.builtin.telescope.defaults.mappings.i["<esc>"] = actions.close
  lvim.builtin.telescope.defaults.winblend = 0

end

local M = {}
M.config = function()
  setup_defaults()
  --  -- See configuration details: https://github.com/LunarVim/LunarVim/issues/2426
  lvim.builtin.telescope.on_config_done = function(tele)
    -- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
    local _, actions = pcall(require, "telescope.actions")
    tele.load_extension("dap")
    tele.load_extension("ui-select")
  end
end

return M
