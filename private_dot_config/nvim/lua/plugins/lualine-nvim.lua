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

    local lsp_status = {
      "lsp_status",
      icon = "",
      symbols = {
        spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
        done = "✓",
        separator = " ",
      },
      ignore_lsp = { "copilot", "GitHub Copilot", "conform", "none-ls", "efm" },
    }

    table.insert(opts.sections.lualine_x, 1, lsp_status)
    table.insert(opts.sections.lualine_x, 2, metals_status)
  end,
}
