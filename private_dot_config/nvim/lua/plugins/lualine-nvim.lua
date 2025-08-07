return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    local icon = _G.LazyVim.config.icons
    local space = {
      function()
        return " "
      end,
    }

    local lsp_status = {
      "lsp_status",
      separator = { left = icon.ui.PowerlineArrowLeft, right = icon.ui.PowerlineRightRounded },
    }

    local no_servers = {
      function()
        return "  No servers"
      end,
      cond = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local buf_clients = vim.lsp.get_clients({ bufnr = bufnr })
        return next(buf_clients) == nil
      end,
      separator = { left = icon.ui.PowerlineLeftRounded, right = icon.ui.PowerlineRightRounded },
    }

    local section_z = vim.tbl_deep_extend("force", opts.sections.lualine_z or {}, {
      lsp_status,
      no_servers,
    })
    opts.sections.lualine_z = section_z
    return opts
  end,
}
