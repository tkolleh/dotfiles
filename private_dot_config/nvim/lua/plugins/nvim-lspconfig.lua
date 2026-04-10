return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Single source of truth for diagnostic display.
    -- Uses Neovim 0.12 current_line to show full detail on cursor line only.
    opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
      underline = false,
      virtual_text = { current_line = false },
      virtual_lines = { current_line = true },
    })
    opts.servers.metals = nil
    opts.setup.metals = nil
    return opts
  end,
}
