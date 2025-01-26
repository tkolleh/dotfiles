-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local utils = require("utils")

local function _map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

_map({ "i", "v" }, "jk", "<ESC>")

-- Disable default keymaps
-- local del = vim.keymap.del
-- del("n", "<leader>bb")
-- del("n", "<leader>wd")
-- del("n", "<leader>l")
-- del("n", "<leader>ft")
-- del("n", "<leader>fT")

Snacks.toggle({
  name = "Dark Colorscheme",
  get = utils.is_background_dark,
  set = function(state)
    if state then
      utils.setDark()
    else
      utils.setLight()
    end
  end,
}):map("<leader>ub")
