return {
  "folke/noice.nvim",
  enabled = true,
  opts = function(_, opts)
    -- Classic cmdline at the bottom of the screen (see noice config defaults).
    -- Completions use Neovim's built-in pum.
    -- VimR's bundled vim treesitter parser lacks the "tab" node, so skip
    -- vim parser highlighting in GUI mode.
    local cmdline_ext = { view = "cmdline" }
    if require("utils").is_gui() then
      cmdline_ext.format = { cmdline = { lang = "" } }
    end
    opts.cmdline = vim.tbl_deep_extend("force", opts.cmdline or {}, cmdline_ext)
    opts.lsp = vim.tbl_deep_extend("force", opts.lsp or {}, {
      hover = { enabled = false },
    })
    opts.presets = vim.tbl_deep_extend("force", opts.presets or {}, {
      command_palette = false,
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
