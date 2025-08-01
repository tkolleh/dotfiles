return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy", -- Or `LspAttach`
  priority = 1000,    -- needs to be loaded in first
  config = function()
    require("tiny-inline-diagnostic").setup()
    -- Only if needed in your configuration, if you already have native LSP diagnostics
    vim.diagnostic.config({
      underline = false,
      virtual_text = false,
      -- update_in_insert = false,
      -- severity_sort = true,
    })
  end,
}
