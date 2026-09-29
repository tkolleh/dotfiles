return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    opts.indent = vim.tbl_deep_extend("force", opts.indent or {}, {
      indent = { enabled = false }, -- hide static per-level guides everywhere
      -- scope.enabled stays at LazyVim's default (true): only the
      -- cursor's current-scope guide remains visible
    })
    return opts
  end,
}
