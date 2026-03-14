return {
  "MeanderingProgrammer/render-markdown.nvim",
  enabled = false,
  opts = {
    preset = "lazy",
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = {},
    },
    checkbox = {
      enabled = false,
    },
    bullet = {
      enabled = true,
      right_pad = 1,
    },
    anti_conceal = { enabled = true },
    win_options = {
      conceallevel = { default = 0, rendered = 0 },
    },
    patterns = {
      markdown = {
        disable = true,
        directives = {
          { id = 17, name = "conceal_lines" },
          { id = 18, name = "conceal_lines" },
        },
      },
    },
    file_types = { "mmd", "md", "markdown", "opencode_output" },
  },
  ft = { "mmd", "md", "markdown", "opencode_output", "norg", "rmd", "org", "codecompanion", "Avante", "copilot-chat" },
  config = function(_, opts)
    require("render-markdown").setup(opts)
    if Snacks and Snacks.toggle then
      Snacks.toggle({
        name = "Render Markdown",
        get = require("render-markdown").get,
        set = require("render-markdown").set,
      }):map("<leader>um")
    end
  end,
}
