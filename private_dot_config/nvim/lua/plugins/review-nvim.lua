return {
  {
    "tkolleh/review.nvim",
    -- dir = vim.fn.expand("~/ws/review.nvim/main"), -- local dev worktree, not GitHub
    dependencies = {
      "esmuellert/codediff.nvim", -- already installed
      "MunifTanjim/nui.nvim",     -- already installed
    },
    cmd = { "Review" },
    keys = {
      { "<leader>r", "<cmd>Review<cr>", desc = "Review" },
      { "<leader>R", "<cmd>Review commits<cr>", desc = "Review commits" },
    },
    opts = {},
  },
}
