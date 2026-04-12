return {
  "OXY2DEV/markview.nvim",
  enabled = true,
  lazy = false,
  ft = { "mmd", "md", "markdown", "opencode_output", "norg", "rmd", "org", "codecompanion", "Avante", "copilot-chat" },
  opts = {
    preview = {
      icon_provider = "mini",
      filetypes = {
        "markdown",
        "md",
        "mmd",
        "opencode_output",
        "norg",
        "rmd",
        "org",
        "codecompanion",
        "Avante",
        "copilot-chat",
      },
      ignore_buftypes = { "nofile" },
      modes = { "n", "no", "c" },
      hybrid_modes = { "n" }, -- Show raw markdown on cursor line (like anti_conceal)
      linewise_hybrid_mode = true,
      edit_range = { 0, 0 }, -- Only current line shows raw
      -- Show code blocks as raw in hybrid mode to keep ``` visible
      raw_previews = {
        markdown = { "code_blocks" },
      },
    },
    markdown = {
      code_blocks = {
        enable = true,
        style = "simple", -- Simple style doesn't hide delimiters
        sign = false,
      },
      headings = {
        enable = true,
        shift_width = 0,
        heading_1 = { style = "simple", sign = false },
        heading_2 = { style = "simple", sign = false },
        heading_3 = { style = "simple", sign = false },
        heading_4 = { style = "simple", sign = false },
        heading_5 = { style = "simple", sign = false },
        heading_6 = { style = "simple", sign = false },
      },
      list_items = {
        enable = true,
        shift_width = 0,
        marker_minus = { add_padding = false },
        marker_plus = { add_padding = false },
        marker_star = { add_padding = false },
        marker_dot = {
          add_padding = false,
          conceal_on_checkboxes = true,
        },
        marker_parenthesis = {
          add_padding = false,
          conceal_on_checkboxes = true,
        },
      },
    },
    markdown_inline = {
      checkboxes = {
        enable = false,
      },
    },
  },
  config = function(_, opts)
    require("markview").setup(opts)

    -- markview dynamically blends bg from fg + Normal bg via OkLab mixing.
    -- Extmark hl_group resolves in global namespace 0, so we must override there.
    local function clear_markview_bg()
      for i = 1, 6 do
        local name = string.format("MarkviewHeading%d", i)
        local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
        hl.bg = nil
        vim.api.nvim_set_hl(0, name, hl)
      end

      local ic = vim.api.nvim_get_hl(0, { name = "MarkviewInlineCode", link = false })
      ic.bg = nil
      vim.api.nvim_set_hl(0, "MarkviewInlineCode", ic)
    end

    clear_markview_bg()

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("markview_heading_bg", { clear = true }),
      pattern = "*",
      -- vim.schedule defers until after markview's own ColorScheme handler
      -- regenerates the palette, so we always apply last.
      callback = function()
        vim.schedule(clear_markview_bg)
      end,
    })
  end,
}
