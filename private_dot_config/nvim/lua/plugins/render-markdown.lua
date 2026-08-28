return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = function(_, opts)
    opts.heading = opts.heading or {}
    opts.heading.backgrounds = {}
    return opts
  end,
}
