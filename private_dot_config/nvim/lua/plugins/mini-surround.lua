--
-- motions to for surrounding text objects
--
return {
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    enabled = true,
    opts = {
      -- stylua: ignore start
      mappings = {
        add            = "sa", -- sa{motion/textobject}{delimiter} Add surrounding in Normal and Visual modes
        delete         = "sd", -- sd{delimiter} Delete surrounding
        find           = "sf", -- Find surrounding (to the right)
        find_left      = "sF", -- Find surrounding (to the left)
        highlight      = "sh", -- Highlight surrounding
        replace        = "sr", -- sr{old}{new} Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`
      },
    },
  },
}
