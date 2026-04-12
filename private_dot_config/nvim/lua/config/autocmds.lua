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
local utils = require("utils")

-- Fix conceallevel for markdown files
-- See: https://www.lazyvim.org/configuration/general#auto-commands
api.nvim_create_autocmd({ "FileType" }, {
  group = api.nvim_create_augroup("markdown_conceal", { clear = true }),
  pattern = { "md", "mmd", "markdown" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto light / dark theme
-- Neovim queries the terminal's background color via OSC 11 at startup
-- (Ghostty supports DEC mode 2031). When the response arrives, Neovim's
-- defaults.lua sets vim.o.background, which fires OptionSet. The nightfox
-- plugin spec (lua/plugins/colorscheme.lua) owns the OptionSet "background"
-- listener that switches between nightfox (dark) and dayfox (light).
--
-- The SnacksDashboardClosed trigger here is a safety net: the dashboard
-- holds startup open past the OSC 11 response window, so we re-apply the
-- theme once the user dismisses it.
-- See: neovim/neovim#31350
api.nvim_create_autocmd("User", {
  pattern = "SnacksDashboardClosed",
  group = api.nvim_create_augroup("dashboard_detect_auto_background", { clear = true }),
  callback = utils.apply_auto_background_theme,
})

-- Sync Pmenu highlight groups with Normal background on colorscheme change.
-- Keeps the native completion popup blended with the editor background.
-- Also sets Neovim 0.12 PmenuBorder and PmenuShadow groups.
local function sync_pmenu_bg()
  local n = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  if n.bg then
    vim.api.nvim_set_hl(0, "Pmenu", { fg = n.fg, bg = n.bg })
    vim.api.nvim_set_hl(0, "PmenuBorder", { fg = n.fg, bg = n.bg })
    vim.api.nvim_set_hl(0, "PmenuShadow", { bg = n.bg })
  end
end

sync_pmenu_bg()

api.nvim_create_autocmd("ColorScheme", {
  group = api.nvim_create_augroup("pmenu-sync", { clear = true }),
  callback = sync_pmenu_bg,
})

-- Disable relative line numbers in CodeDiff tabs
-- CodeDiff opens in a new tab; when closed, these windows are destroyed,
-- so the original tab's relativenumber settings remain intact.
api.nvim_create_autocmd("User", {
  pattern = "CodeDiffOpen",
  group = api.nvim_create_augroup("codediff_disable_relativenumber", { clear = true }),
  callback = function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      vim.wo[win].relativenumber = false
    end
  end,
  desc = "Disable relative line numbers in CodeDiff tabs",
})
