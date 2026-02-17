-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

-- Python Configuration
-- Priority: NVIM_VENV > System Python (Resolved)

-- 1. Resolve system python path (handling uv/symlinks)
local system_python = vim.fn.exepath("python3")
local real_system_python_path = system_python
if system_python ~= "" then
  real_system_python_path = (vim.uv or vim.loop).fs_realpath(system_python) or system_python
end

-- 2. Determine preferred python executable and directory
local utils = require("utils")
local python_executable = real_system_python_path
local python_bin_dir = nil

if not utils.is_nil_or_empty(vim.env.NVIM_VENV) then
  -- Case A: Use NVIM_VENV
  python_bin_dir = vim.env.NVIM_VENV .. "/bin"
  python_executable = python_bin_dir .. "/python"
elseif real_system_python_path ~= system_python then
  -- Case B: Use Resolved System Python (if symlinked)
  -- We only need to prepend to PATH if the real path differs from the one in PATH
  python_bin_dir = vim.fn.fnamemodify(real_system_python_path, ":h")
end

-- 3. Update PATH (Essential for Mason to find the correct python)
if python_bin_dir then
  vim.env.PATH = python_bin_dir .. ":" .. vim.env.PATH
end

-- 4. Set Host Prog (Essential for Neovim python provider)
vim.g.python3_host_prog = python_executable

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
