-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

local api = vim.api

-- Hocon_group
-- See: https://github.com/antosha417/tree-sitter-hocon
local hocon_group = api.nvim_create_augroup("hocon", { clear = true })
api.nvim_create_autocmd(
  { "BufNewFile", "BufRead" },
  { group = hocon_group, pattern = "*.conf", command = "set ft=hocon" }
)

-- Function to show the column if a line exceeds the specified length
local function show_column_if_line_too_long(length_limit)
  local max_line_length = 0
  for _, line in ipairs(api.nvim_buf_get_lines(0, 0, -1, false)) do
    max_line_length = math.max(max_line_length, #line)
  end

  if max_line_length > length_limit then
    vim.cmd("highlight ColorColumn ctermbg=red guibg=red")
    vim.wo.colorcolumn = tostring(length_limit + 1)
  else
    vim.wo.colorcolumn = ""
  end
end

-- Create an augroup for line wraps
-- local line_wrap_guide = api.nvim_create_augroup("line_wrap_group", { clear = true })
-- -- Add autocommands to the group for drawing a column marking the maximum line length
-- api.nvim_create_autocmd(
--   { "BufRead", "TextChanged", "TextChangedI" },
--   {
--     group = line_wrap_guide,
--     pattern = { "*.js", "*.ts", "*.hs", "*.scala", "*.py", "*.java" },
--     callback = function() show_column_if_line_too_long(120) end,
--   }
-- )
