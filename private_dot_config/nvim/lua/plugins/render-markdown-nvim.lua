return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
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
    anti_conceal = { enabled = false },
    file_types = { "markdown", "opencode_output" },
  },
  ft = { "markdown", "norg", "rmd", "org", "codecompanion", "Avante", "copilot-chat", "opencode_output" },
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
