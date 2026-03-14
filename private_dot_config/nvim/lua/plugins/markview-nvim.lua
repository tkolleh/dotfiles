return {
  "OXY2DEV/markview.nvim",
  enabled = true,
  lazy = false,
  ft = { "mmd", "md", "markdown", "opencode_output", "norg", "rmd", "org", "codecompanion", "Avante", "copilot-chat" },
  opts = {
    preview = {
      icon_provider = "mini",
      filetypes = { "markdown", "md", "mmd", "opencode_output", "norg", "rmd", "org", "codecompanion", "Avante", "copilot-chat" },
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
        shift_width = 1,
        heading_1 = { style = "simple", sign = false },
        heading_2 = { style = "simple", sign = false },
        heading_3 = { style = "simple", sign = false },
        heading_4 = { style = "simple", sign = false },
        heading_5 = { style = "simple", sign = false },
        heading_6 = { style = "simple", sign = false },
      },
      list_items = {
        enable = true,
        shift_width = 4,
        marker_dot = {
          add_padding = true,
          conceal_on_checkboxes = true,
        },
        marker_parenthesis = {
          add_padding = true,
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
}
