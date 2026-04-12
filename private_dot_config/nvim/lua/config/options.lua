-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

-- Python Configuration
-- Priority: NVIM_VENV > System Python (Resolved)
--
-- 1. Resolve system python path (handling uv/symlinks)
local system_python = vim.fn.exepath("python3")
local real_system_python_path = system_python
if system_python ~= "" then
  real_system_python_path = vim.uv.fs_realpath(system_python) or system_python
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

-- Node Configuration
-- Explicitly set node host prog to avoid checkhealth warnings with volta/nvm
local node_host = vim.fn.exepath("neovim-node-host")
if node_host ~= "" then
  vim.g.node_host_prog = node_host
end

-- Disable unused providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- cmdheight=1: ui2 eliminates "Press ENTER" prompts; no extra height needed
vim.opt.cmdheight = 1
-- Enable line wrap
vim.opt.wrap = true
--  make floating windows transparentish
--  VimR needs slight transparency to blend rounded border corners
-- vim.o.winblend = require("utils").is_gui() and 15 or 0
vim.o.winblend = 0
--  and give them rounded borders by default
--  VimR's single-grid renderer mishandles winborder, hiding cmdline text
--if not require("utils").is_gui() then
vim.o.winborder = "rounded"
--end
-- Neovim 0.12: dedicated popup menu border option (independent of winborder)
vim.o.pumborder = "rounded"

-- Neovim 0.12 native UI: replaces noice.nvim.
-- targets='msg': status messages appear in an ephemeral floating window (bottom-right).
-- timeout: message visible for 3 seconds before fading.
require("vim._core.ui2").enable({
  msg = {
    targets = "msg",
    msg = { timeout = 3000 },
  },
})

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

-- Enhanced diff options for better character-level diff detection
vim.opt.diffopt:append({
  "internal", -- Use internal diff library
  "filler", -- Show filler lines
  "closeoff", -- Close diff windows when one is closed
  "vertical", -- Use vertical splits for diffs
  "linematch:60", -- Enable character-level diff detection
  "algorithm:minimal", -- Use minimal diff algorithm
  "iwhite", -- Ignore whitespace changes
})

vim.filetype.add({
  extension = {
    conf = "hocon",
    hocon = "hocon",
  },
})

-- Default to **no** line nor text display for diagnostics
utils.cycle_diagnostics_display({ virtual_text = false, virtual_lines = false })
