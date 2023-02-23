local M = {}
-- Helper functions
--
-- re-assign lvim defaults
M.which_key_change_key = function(from, to)
  local mapping = lvim.builtin.which_key.mappings[from]
  lvim.builtin.which_key.mappings[to] = mapping
  lvim.builtin.which_key.mappings[from] = nil
end

-- Changes an existing mapping to a completely new one. Old mapping is deleted,
-- so should be re-assigned first.
M.which_key_set_key = function(key, mapping)
  lvim.builtin.which_key.mappings[key] = nil
  lvim.builtin.which_key.mappings[key] = mapping
end

return M
