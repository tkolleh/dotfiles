return {
  "folke/tokyonight.nvim",
  lazy = true,
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {
      on_colors = function(colors)
        local bg = "#f9f7fa"
        if vim.o.background == "light" then
          colors.bg = bg
        end
      end,
    })
  end,
}
