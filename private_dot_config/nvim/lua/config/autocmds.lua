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

-- Set hocon filetype for .conf files
-- See: https://github.com/antosha417/tree-sitter-hocon
api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = api.nvim_create_augroup("hocon", { clear = true }),
  pattern = "*.conf",
  command = "set ft=hocon"
})

-- Fix conceallevel for markdown files
-- See: https://www.lazyvim.org/configuration/general#auto-commands
api.nvim_create_autocmd({ "FileType" }, {
  group = api.nvim_create_augroup("markdown_conceal", {clear = true}),
  pattern = { "mmd", "markdown", "mmd" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- FIXME: This currently does not work as expected
-- Auto light / dark theme
-- The decision will be made based on system preferences using DEC mode 2031 if supported by the terminal.
-- See: neovim/neovim#31350
-- api.nvim_create_autocmd({"VimEnter","UIEnter","BufWinEnter","StdinReadPre", "OptionSet"}, {
--   group = api.nvim_create_augroup('detect_auto_background', { clear = true }),
--   pattern = 'background',
--   callback = function()
--     local utils = require("utils")
--     if utils.is_background_dark() then
--       utils.setDark()
--     else
--       utils.setLight()
--     end
--   end,
-- })
