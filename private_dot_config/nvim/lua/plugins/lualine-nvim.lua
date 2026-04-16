return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    local metals_status = {
      function()
        return vim.g.metals_status or ""
      end,
      cond = function()
        return (vim.g.metals_status or "") ~= ""
      end,
      color = function()
        return { fg = Snacks.util.color("DiagnosticInfo") }
      end,
    }

    -- LSP progress is handled by noice.nvim
    table.insert(opts.sections.lualine_x, 1, metals_status)
  end,
}
