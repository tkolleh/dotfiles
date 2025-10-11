--
-- nvim/lua/plugins/nvim-window-picker.lua
-- ========================================
--
-- Every file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- Plugin files can:
--  * add extra plugins
--  * disable/enabled LazyVim plugins
--  * override the configuration of LazyVim plugins
return {
  { 
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "auto", -- latte, frappe, macchiato, mocha
      background = { -- :h background
          light = "latte",
          dark = "mocha",
      },
      default_integrations = true,
      auto_integrations = true,
    }
  },
  { "EdenEast/nightfox.nvim" },
  { "yorik1984/newpaper.nvim" },
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false,     -- make sure we load this during startup if it is your main colorscheme
    -- priority = 1000,  -- make sure to load this before all the other start plugins
  },
  {
    "LazyVim/LazyVim",
    opts = function(opts)
      local icon = require('lib.icons')
      opts.icons = vim.tbl_deep_extend("force", icon or {}, opts.icons or {})
      opts.news = vim.tbl_deep_extend("force", opts.news or {}, {
        -- When enabled, NEWS.md will be shown when changed.
        -- This only contains big new features and breaking changes.
        lazyvim = true,
        -- Same but for Neovim's news.txt
        neovim = true,
      })
      local utils = require("utils")
      opts.colorscheme = "catppuccin"
      return opts
    end,
  },
}
