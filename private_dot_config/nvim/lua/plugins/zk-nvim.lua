return {
  "zk-org/zk-nvim",
  opts = {},
  config = function(_, opts)
    local zk = require("zk")
    local commands = require("zk.commands")

    zk.setup({
      -- Can be "telescope", "fzf", "fzf_lua", "minipick", "snacks_picker",
      -- or "select" (`vim.ui.select`).
      -- Note: "fzf" requires junegunn/fzf.vim, use "fzf_lua" for ibhagwan/fzf-lua
      picker = "fzf_lua",
      lsp = {
        -- `config` is passed to `vim.lsp.start(config)`
        config = {
          name = "zk",
          cmd = { "zk", "lsp" },
          filetypes = { "markdown" },
          -- on_attach = ...
          -- etc, see `:h vim.lsp.start()`
        },
        -- automatically attach buffers in a zk notebook that match the given filetypes
        auto_attach = {
          enabled = true,
        },
      },
    })

    -- Custom Commands
    ---Create or open today's daily note
    commands.add("ZkDaily", function(options)
      options = vim.tbl_extend("force", { group = "daily", dir = "journals/daily" }, options or {})
      zk.new(options)
    end)
  end,
}
