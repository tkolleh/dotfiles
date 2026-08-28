return {
  "nvim-mini/mini.nvim",
  version = false,
  event = "VeryLazy",
  config = function()
    local statuscolumn = require("mini.statuscolumn")
    statuscolumn.setup({
      content = statuscolumn.gen_content.main({
        { fold = "%C", lnum = "%l", sign = "%s" },
        { format = "=lfs", sep = "▏" },
        { ltype = "virt", lnum = "•" },
        { ltype = "wrap", pos = "cursor", lnum = "↪" },
        { ltype = "wrap", pos = "above", lnum = "%#MiniStatuscolumnWrapDim#↪" },
        { ltype = "wrap", pos = "below", lnum = "%#MiniStatuscolumnWrapDim#↪" },
        { win = "inactive", sep = " " },
      }),
    })
  end,
}
