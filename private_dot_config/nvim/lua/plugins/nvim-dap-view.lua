return {
  "igorlfs/nvim-dap-view",
  dependencies = { "mfussenegger/nvim-dap" },
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
    -- Winbar configuration
    winbar = {
      show = true,
      sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
    },
    -- Window layout configuration (replaces invalid 'layout' option)
    windows = {
      size = 0.3, -- Height as ratio (30% of screen)
      position = "below", -- Position at bottom
    },
  },
  config = function(_, opts)
    require("dap-view").setup(opts)

    -- Auto open/close dap-view using dap listeners
    -- (replaces invalid 'auto_toggle' option)
    local dap = require("dap")
    local dv = require("dap-view")

    dap.listeners.after.event_initialized["dapview_config"] = function()
      dv.open()
    end

    dap.listeners.before.event_terminated["dapview_config"] = function()
      dv.close()
    end

    dap.listeners.before.event_exited["dapview_config"] = function()
      dv.close()
    end
  end,
}
