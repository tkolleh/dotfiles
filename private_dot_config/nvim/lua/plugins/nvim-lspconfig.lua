return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.diagnostics.virtual_text = false
    opts.diagnostics.virtual_lines = false
    opts.servers.metals = nil
    opts.setup.metals = nil
    return opts
  end,
}
