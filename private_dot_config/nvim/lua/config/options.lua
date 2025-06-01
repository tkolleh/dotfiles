-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.opt.wrap = true -- Enable line wrap

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
