local M = {}
-- Helper functions
--

-- Map a single key, leader key is included.
M.which_key_map_key = function(key, mapping)
  lvim.builtin.which_key.mappings[key] = mapping
end

-- Remove a single Whichkey keybinding
M.which_key_remove_key = function(key)
  lvim.builtin.which_key.mappings[key] = {}
end

-- Add a single key to a Whichkey submenu
M.which_key_map_submenu_key = function(menu, key, mapping)
  local k = menu .. key
  lvim.builtin.which_key.mappings[k] = mapping
end

return M
