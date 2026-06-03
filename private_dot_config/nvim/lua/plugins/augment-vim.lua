return {
  "augmentcode/augment.vim",
  cmd = "Augment",
  keys = {
    { "<leader>aa", "<cmd>Augment chat-toggle<cr>", desc = "Toggle Augment chat" },
    { "<leader>ac", "<cmd>Augment chat<cr>", desc = "Send Augment chat message" },
  },
  init = function()
    vim.g.augment_disable_tab_mapping = true
  end,
}
