return {
  "folke/noice.nvim",
  opts = function(_, opts)
    -- Enable command palette preset for centered cmdline
    opts.presets = opts.presets or {}
    opts.presets.command_palette = true

    -- Route specific msg_show events to the mini view
    opts.routes = opts.routes or {}
    table.insert(opts.routes, {
      filter = {
        event = "msg_show",
        any = {
          { find = "%d+L, %d+B" }, -- written
          { find = "; after #%d+" }, -- undo
          { find = "; before #%d+" }, -- redo
        },
      },
      view = "mini",
    })

    -- Configure views
    opts.views = opts.views or {}

    -- Mini view configuration (ephemeral bottom-right)
    opts.views.mini = vim.tbl_deep_extend("force", opts.views.mini or {}, {
      timeout = 3000,
      position = {
        row = -3,
        col = "100%",
      },
      border = {
        style = "rounded",
      },
      win_options = {
        winblend = 0,
      },
    })

    -- Cmdline popup view configuration (centered)
    opts.views.cmdline_popup = vim.tbl_deep_extend("force", opts.views.cmdline_popup or {}, {
      border = {
        style = "rounded",
      },
      win_options = {
        winblend = 0,
      },
    })

    -- Popupmenu view configuration
    opts.views.popupmenu = vim.tbl_deep_extend("force", opts.views.popupmenu or {}, {
      border = {
        style = "rounded",
      },
      win_options = {
        winblend = 0,
      },
    })
  end,
}
