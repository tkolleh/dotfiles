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
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
  },

}
