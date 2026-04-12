return {
  -- disable flash: prefer vim motions and text objects to get around
  { "folke/flash.nvim", enabled = false },
  -- disable nvim-dap-ui: replaced by nvim-dap-view
  { "rcarriga/nvim-dap-ui", enabled = false },
  -- disable noice.nvim: replaced by vim._core.ui2 (Neovim 0.12 native UI)
  { "folke/noice.nvim", enabled = false },
}
