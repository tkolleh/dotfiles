-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

-- Custom pyton provider
local utils = require("utils")
if not utils.is_nil_or_empty(vim.env.NVIM_VENV) then
  vim.g.python3_host_prog = vim.env.NVIM_VENV .. "/bin/python"
else
  -- Fallback to system python3
  vim.g.python3_host_prog = vim.fn.exepath("python3")
end

-- Raise the bar a bit
vim.opt.cmdheight = 1

vim.opt.wrap = true -- Enable line wrap

--  make floating windows transparentish
vim.o.winblend = 0
--  and give them rounded borders by default
vim.o.winborder = "rounded"

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

vim.o.showbreak = "↪ "

-- Default to **no** line nor text display for diagnostics
utils.cycle_diagnostics_display({ virtual_text = false, virtual_lines = false })

-- Enhanced diff options for better character-level diff detection
vim.opt.diffopt:append({
  "internal",     -- Use internal diff library
  "filler",       -- Show filler lines
  "closeoff",     -- Close diff windows when one is closed
  "vertical",     -- Use vertical splits for diffs
  "linematch:60", -- Enable character-level diff detection
  "algorithm:minimal", -- Use minimal diff algorithm
  "iwhite",       -- Ignore whitespace changes
})

vim.opt_local.conceallevel = 0
