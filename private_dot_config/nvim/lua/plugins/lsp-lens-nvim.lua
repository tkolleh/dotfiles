return {
  'tkolleh/lsp-lens.nvim',
  -- 'lsp-lens.nvim',
  -- name = "lsp-lens.nvim",
  -- dev = true,
  enabled = true,
  event = "LspAttach", -- Or `LspAttach`
  priority = 1000,    -- needs to be loaded in first
  config = function(_, opts)
    opts = vim.tbl_deep_extend("keep", {
      enable = true,
      include_declaration = false,      -- Reference include declaration
      sections = {                      -- Enable / Disable specific request, formatter example looks 'Format Requests'
        definition = true,
        references = true,
        implements = true,
        git_authors = true,
      },
    }, opts or {})
    require("lsp-lens").setup(opts)
  end
}
