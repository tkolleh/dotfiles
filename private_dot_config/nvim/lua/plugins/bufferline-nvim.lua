  -- Customize bufferline
return {
  "akinsho/nvim-bufferline.lua",
  enabled = true,
  event = 'VeryLazy',
  version = '*',
  opts = {
    options = {
      indicator = {
        -- icon = "▎", -- this should be omitted if indicator style is not 'icon'
        style = "underline", -- 'icon' | 'underline' | 'none',
      },
      ---@type 'thin' | 'thick' | 'slant' | 'padded_slant' | 'slope' | 'padded_slope'
      separator_style = 'slant',
      always_show_bufferline = true,
    },
  },
}
