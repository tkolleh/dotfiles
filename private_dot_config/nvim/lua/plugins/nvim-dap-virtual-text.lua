return {
  "theHamsta/nvim-dap-virtual-text",
  -- Everything below used to just restate the plugin's own defaults
  -- (enabled, highlight_*, show_stop_reason, commented, only_first_definition,
  -- all_references, clear_on_continue, all_frames, virt_lines,
  -- virt_text_win_col, display_callback -- all confirmed identical to
  -- nvim-dap-virtual-text.lua's own `options` table). `virt_text_pos` is left
  -- unset too: the plugin's own default is already "inline" on Neovim 0.10+
  -- (`vim.fn.has('nvim-0.10') == 1 and 'inline' or 'eol'`), which covers this
  -- config's nvim 0.12. `enabled_commands` (note: not a real key -- the
  -- plugin reads `enable_commands`, no "d") is dropped rather than fixed:
  -- that default is also already `true`.
  opts = {},
  config = function(_, opts)
    require("nvim-dap-virtual-text").setup(opts)

    -- Custom highlight groups to match color scheme
    -- Link to existing highlight groups for consistency with haunt.nvim
    vim.api.nvim_set_hl(0, "NvimDapVirtualText", { link = "Comment" })
    vim.api.nvim_set_hl(0, "NvimDapVirtualTextError", { link = "DiagnosticVirtualTextError" })
    vim.api.nvim_set_hl(0, "NvimDapVirtualTextChanged", { link = "DiagnosticVirtualTextWarn" })
  end,
}
