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
    "oskarnurm/koda.nvim",
    enabled = false,
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- require("koda").setup({ transparent = true })
      vim.cmd("colorscheme koda")
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = false,
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 800, -- make sure to load this before all the other start plugins
    opts = {
      flavour = "auto", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      default_integrations = true,
      auto_integrations = true,
    },
  },
  {
    "EdenEast/nightfox.nvim",
    name = "nightfox",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 800, -- make sure to load this before all the other start plugins
    config = function()
      -- nightfox compiles variant-specific highlight blobs that hardcode
      -- vim.o.background at compile time. When LazyVim loads the colorscheme
      -- at startup the OSC 11 background response from Ghostty (DEC mode 2031)
      -- may not have arrived yet, so the wrong variant can be active.
      -- This OptionSet listener re-applies the correct variant whenever
      -- Neovim's background detection updates vim.o.background post-startup.
      vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "background",
        group = vim.api.nvim_create_augroup("nightfox-bg-sync", { clear = true }),
        desc = "Switch nightfox variant when OSC 11 updates background",
        callback = function()
          local target = vim.o.background == "light" and "dayfox" or "nightfox"
          if vim.g.colors_name ~= target then
            vim.cmd.colorscheme(target)
          end
        end,
      })
    end,
  },
  {
    "yorik1984/newpaper.nvim",
    enabled = false,
  },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    enabled = false,
  },
  {
    "LazyVim/LazyVim",
    opts = function(opts)
      local icon = require("lib.icons")
      opts.icons = vim.tbl_deep_extend("force", icon or {}, opts.icons or {})
      opts.news = vim.tbl_deep_extend("force", opts.news or {}, {
        -- When enabled, NEWS.md will be shown when changed.
        -- This only contains big new features and breaking changes.
        lazyvim = true,
        -- Same but for Neovim's news.txt
        neovim = true,
      })
      -- Use a function so the variant is chosen at load time, after Neovim's
      -- OSC 11 terminal query has had a chance to set vim.o.background.
      opts.colorscheme = function()
        local scheme = vim.o.background == "light" and "dayfox" or "nightfox"
        vim.cmd.colorscheme(scheme)
      end
      return opts
    end,
  },
}
