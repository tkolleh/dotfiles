return {
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup({
        -- { "ivy", "default" },
        files = { formatter = "path.filename_first" },
        grep = { formatter = "path.filename_first" },
        oldfiles = { formatter = "path.filename_first" },
      })
    end,
  },
}
