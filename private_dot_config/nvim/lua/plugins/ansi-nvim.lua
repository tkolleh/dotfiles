return {
  "0xferrous/ansi.nvim",
  config = function()
    require("ansi").setup({
      auto_enable = true, -- Auto-enable for configured filetypes (default: false)
    })
  end,
}
