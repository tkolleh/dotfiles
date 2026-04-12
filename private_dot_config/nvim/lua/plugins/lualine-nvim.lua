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

    -- Neovim 0.12 native LSP progress via vim.lsp.status() — no plugin dependency.
    local lsp_progress = {
      function()
        return vim.lsp.status()
      end,
      cond = function()
        return vim.lsp.status() ~= ""
      end,
      color = function()
        return { fg = Snacks.util.color("DiagnosticInfo") }
      end,
    }

    table.insert(opts.sections.lualine_x, 1, lsp_progress)
    table.insert(opts.sections.lualine_x, 2, metals_status)
  end,
}
