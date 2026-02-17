--
-- Run installed linters
-- Customize default linter
return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- Removed invalid markdownlint config
      return opts
    end,
  },
}
