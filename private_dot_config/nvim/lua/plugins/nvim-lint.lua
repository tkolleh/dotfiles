--
-- Run installed linters
-- Customize default linter
return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local markdownlint = require("lint").linters.markdownlint
      markdownlint.args = {
        "--config",
        vim.fn.expand("~/.config/linters/markdownlint.json"),
      }
      local markdownlint_cli2 = require("lint").linters["markdownlint-cli2"]
      markdownlint_cli2.args = {
        "--config",
        vim.fn.expand("~/.config/linters/markdownlint.json"),
      }
      return opts
    end,
  },
}
