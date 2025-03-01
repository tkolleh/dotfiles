return {
  {
    "ibhagwan/fzf-lua",
    opts = function(_, opts)
      local horizontal_winopts = {
        preview = {
          layout = "vertical",
          vertical = "down:15,border-top",
        },
      }
      opts.files = vim.tbl_deep_extend("force", opts.files, {
        cwd_prompt = true,
        winopts = horizontal_winopts,
      })
      opts.grep = vim.tbl_deep_extend("force", opts.grep, {
        cwd_prompt = true,
        winopts = horizontal_winopts,
      })

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        formatter = "path.filename_first",
        -- formatter = "path.dirname_first",
      })
    end,
  },
}
