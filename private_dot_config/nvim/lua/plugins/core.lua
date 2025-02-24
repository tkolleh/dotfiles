--
-- nvim/lua/plugins/core.lua
-- ========================================
--

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins

local utils = require("utils")

return {
  -- add gruvbox theme
  { "ellisonleao/gruvbox.nvim" },

  -- add github theme
  -- Install without configuration
  { "projekt0n/github-nvim-theme", name = "github-theme" },

  -- Customize bufferline
  {
    "akinsho/nvim-bufferline.lua",
    event = "VeryLazy",
    opts = {
      options = {
        separator_style = "slant" or "padded_slant",
        always_show_bufferline = true,
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        if utils.is_background_dark() then
          utils.setDark()
        else
          utils.setLight()
        end
      end,
    },
  },
}
