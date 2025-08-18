-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

-- Custom pyton provider
local util = require("utils")
if not util.is_nil_or_empty(vim.env.NVIM_VENV) then
  vim.g.python3_host_prog = vim.env.NVIM_VENV .. "/bin/python"
else
  -- Fallback to system python3
  vim.g.python3_host_prog = vim.fn.exepath("python3")
end

-- Raise the bar a bit
vim.opt.cmdheight = 1

vim.opt.wrap = true -- Enable line wrap

--  make floating windows transparentish
vim.o.winblend = 5
--  and give them rounded borders by default
vim.o.winborder = 'rounded'

-- LazyVim picker to use.
-- Can be one of: telescope, fzf
-- Leave it to "auto" to automatically use the picker
-- enabled with `:LazyExtras`
vim.g.lazyvim_picker = "fzf"

-- set to `true` to follow the main branch
-- you need to have a working rust toolchain to build the plugin
-- in this case.
vim.g.lazyvim_blink_main = false

-- Diable auto formatting via [confrom.nvim](https://github.com/stevearc/conform.nvim)
-- See lavyvim ref: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
-- use <leader>uf to enable formatting
vim.g.autoformat = false

-- Nvim 0.11.0+ has breaking change causing borders of floating windows to vanish
-- due to Neovim no longer using global callbacks. Use `winborder` to set the 
-- default border for all floating windows.
vim.o.winborder = 'rounded'

vim.o.showbreak = '↪ '
