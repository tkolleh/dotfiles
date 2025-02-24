--
-- Configure LazyVim to load dark or light mode scheme
--
local utils = require("utils")
return {
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      set_dark_mode = utils.setDark,
      set_light_mode = utils.setLight,
      update_interval = 9000,
      fallback = "dark",
    },
  },
}
