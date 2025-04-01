return {
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup({
        { "ivy", "fzf-native" },
        files = { formatter = "path.filename_first" },
        buffers = { formatter = "path.filename_first" },
        grep = { formatter = "path.filename_first" },
        oldfiles = { formatter = "path.filename_first" },
      })
    end,
  },
}
