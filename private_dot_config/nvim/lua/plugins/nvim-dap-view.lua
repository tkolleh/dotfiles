return {
  "igorlfs/nvim-dap-view",
  dependencies = { "mfussenegger/nvim-dap" },
  init = function()
    -- Ensure dap-view loads when nvim-dap loads so listeners register before sessions start
    local group = vim.api.nvim_create_augroup("dapview_lazy_load", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "LazyLoad",
      callback = function(ev)
        if ev.data == "nvim-dap" then
          require("lazy").load({ plugins = { "nvim-dap-view" } })
          return true
        end
      end,
    })
  end,
  keys = {
    {
      "<leader>du",
      function()
        require("dap-view").toggle()
      end,
      desc = "Dap View",
    },
    {
      "<leader>de",
      function()
        require("dap").eval()
      end,
      desc = "Eval",
      mode = { "n", "x" },
    },
  },

  ---@module 'dap-view'
  ---@type dapview.Config
  opts = {
    auto_toggle = true,
    winbar = {
      show = true,
      sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
    },
    windows = {
      size = 0.3,
      position = "below",
    },
  },
  config = function(_, opts)
    require("dap-view").setup(opts)

    -- Disable auto-close while keeping auto-open from auto_toggle = true
    -- The built-in close listeners are registered as `before` handlers with id "dap-view"
    -- The `after` handlers (view refresh, winbar redraw, scroll cleanup) remain intact
    local dap = require("dap")
    dap.listeners.before.event_terminated["dap-view"] = nil
    dap.listeners.before.disconnect["dap-view"] = nil
  end,
}
