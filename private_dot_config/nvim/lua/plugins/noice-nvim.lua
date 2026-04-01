return {
  "folke/noice.nvim",
  opts = function(_, opts)
    if require("utils").is_gui() then
      -- VimR's bundled vim treesitter parser lacks the "tab" node.
      -- Keep noice cmdline enabled but skip vim parser highlighting.
      opts.cmdline = vim.tbl_deep_extend("force", opts.cmdline or {}, {
        format = {
          cmdline = { lang = "" },
        },
      })
    end
    -- Position cmdline popup and completion list with a gap between them
    local shared_hl = { Normal = "Normal", FloatBorder = "FloatBorder" }
    opts.views = vim.tbl_deep_extend("force", opts.views or {}, {
      cmdline_popup = {
        position = { row = 5, col = "50%" },
        size = { width = 60, height = "auto" },
        border = { style = "rounded", padding = { 0, 1 } },
        win_options = { winhighlight = shared_hl },
      },
      popupmenu = {
        relative = "editor",
        position = { row = 11, col = "50%" },
        size = { width = 60, height = 10 },
        border = { style = "rounded", padding = { 0, 1 } },
        win_options = { winhighlight = shared_hl },
      },
    })

    return opts
  end,
  config = function(_, opts)
    require("noice").setup(opts)

    -- Sync native Pmenu bg with Normal so cmdline completion
    -- matches the editor background
    local function sync_pmenu_bg()
      local n = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
      if n.bg then
        vim.api.nvim_set_hl(0, "Pmenu", { fg = n.fg, bg = n.bg })
      end
    end

    sync_pmenu_bg()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("noice-pmenu-sync", { clear = true }),
      callback = sync_pmenu_bg,
    })
  end,
}
