return {
  "folke/noice.nvim",
  opts = function(_, opts)
    if require("utils").is_gui() then
      opts.cmdline = { enabled = false }
      opts.presets = vim.tbl_deep_extend("force", opts.presets or {}, {
        command_palette = false,
        bottom_search = false,
      })
    end
    return opts
  end,
}
