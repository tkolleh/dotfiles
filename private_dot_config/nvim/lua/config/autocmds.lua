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

-- Auto light / dark theme
-- The decision will be made based on system preferences using DEC mode 2031 if supported by the terminal.
-- See: neovim/neovim#31350
api.nvim_create_autocmd({"VimEnter","UIEnter","BufWinEnter","StdinReadPre", "OptionSet"}, {
  group = api.nvim_create_augroup('detect_auto_background', { clear = true }),
  pattern = 'background',
  callback = function()
    local utils = require("utils")
    if utils.is_background_dark() then
      utils.setDark()
    else
      utils.setLight()
    end
  end,
})
