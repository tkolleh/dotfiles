return {
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup({ { "ivy", "hide" } })
    end,
    opts = function(_, opts)
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        formatter = "path.filename_first",
        -- formatter = "path.dirname_first",
      })
    end,
  },
}
