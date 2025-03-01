return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers.metals = nil
    opts.setup.metals = nil
    return opts
  end,
}
