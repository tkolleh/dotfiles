return {
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup({
        { "ivy", "fzf-native" },
        defaults = { formatter={"path.filename_first",2} }
        -- files = { formatter = "path.filename_first" },
        -- buffers = { formatter = "path.filename_first" },
        -- grep = { formatter = "path.filename_first" },
        -- oldfiles = { formatter = "path.filename_first" },
        -- lsp_implementations = { formatter = "path.filename_first" },
        -- lsp_references = { formatter = "path.filename_first" },
      })
    end,
  },
}
