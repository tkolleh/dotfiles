--
-- Run installed linters
-- Customize default linter
return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      markdown = { "markdownlint" },
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "pylint" },
      -- Use the "*" filetype to run linters on all filetypes.
      -- ['*'] = { 'global linter' },
      -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
      -- ['_'] = { 'fallback linter' },
      -- ["*"] = { "typos" },
    },
    -- LazyVim extension to easily override linter options
    -- or add custom linters.
    ---@type table<string,table>
    linters = {
      -- -- Example of using selene only when a selene.toml file is present
      -- selene = {
      --   -- `condition` is another LazyVim extension that allows you to
      --   -- dynamically enable/disable linters based on the context.
      --   condition = function(ctx)
      --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
      --   end,
      -- },
    },
  },
  config = function(_, opts)
    local lint = require("lint")
    lint.linters.markdownlint.args = {
      "--disable",
      "MD012", -- allow multiple consecutive blank lines
      "MD013", -- disable line length limit
      "MD024", -- allow multiple headings with the same comment
      "MD030", -- allow spaces after list markers
      "MD033", -- allow inline HTML
      "MD036", -- allow emphasis blocks
      "MD040", -- allow code blocks without language specification
      "MD041", -- allow non-headers on the first line, e.g. meta section
      "MD046", -- allow mixed code-block styles
    }
  end,
}
