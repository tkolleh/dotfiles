return {
  "theHamsta/nvim-dap-virtual-text",
  opts = {
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    only_first_definition = true,
    all_references = false,
    clear_on_continue = false,
    -- Use inline virtual text for Neovim 0.10+
    virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
    -- Experimental features
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil,
    -- Display callback (default)
    display_callback = function(variable, buf, stackframe, node, options)
      -- By default, strip out new line characters
      if options.virt_text_pos == "inline" then
        return " = " .. variable.value:gsub("%s+", " ")
      else
        return variable.name .. " = " .. variable.value:gsub("%s+", " ")
      end
    end,
  },
  config = function(_, opts)
    require("nvim-dap-virtual-text").setup(opts)

    -- Custom highlight groups to match color scheme
    -- Link to existing highlight groups for consistency with haunt.nvim
    vim.api.nvim_set_hl(0, "NvimDapVirtualText", { link = "Comment" })
    vim.api.nvim_set_hl(0, "NvimDapVirtualTextError", { link = "DiagnosticVirtualTextError" })
    vim.api.nvim_set_hl(0, "NvimDapVirtualTextChanged", { link = "DiagnosticVirtualTextWarn" })
  end,
}
