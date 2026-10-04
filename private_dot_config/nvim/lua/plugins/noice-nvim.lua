return {
  "folke/noice.nvim",
  opts = function(_, opts)
    -- Border glyphs match goto-preview's override (lua/plugins/goto-preview.lua)
    -- so noice and goto-preview floats read as one unified popup family.
    local POPUP_BORDER = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }

    -- Suppress "No information available" notify on empty LSP hover (K)
    opts.lsp = vim.tbl_deep_extend("force", opts.lsp or {}, {
      hover = { silent = true },
    })

    -- Enable command palette preset for centered cmdline
    opts.presets = opts.presets or {}
    opts.presets.command_palette = true

    -- Explicitly disabled: this preset only sets `border.style = "rounded"`
    -- and `position = {row=2, col=2}` on the hover view (noice/config/preset.lua).
    -- The opts.views.hover block below already owns border styling (POPUP_BORDER,
    -- matching goto-preview) more completely than this preset does, so enabling
    -- it would be redundant at best. Left as a live risk otherwise: presets merge
    -- into Config.options before opts.views is deep-merged on top, and since our
    -- hover override never sets `position`, enabling this preset would silently
    -- reintroduce its row=2/col=2 offset with no corresponding visual reason tied
    -- to our custom border glyphs.
    opts.presets.lsp_doc_border = false

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
        style = POPUP_BORDER,
      },
      win_options = {
        winblend = 0,
      },
    })

    -- Cmdline popup view configuration (centered)
    opts.views.cmdline_popup = vim.tbl_deep_extend("force", opts.views.cmdline_popup or {}, {
      border = {
        style = POPUP_BORDER,
      },
      win_options = {
        winblend = 0,
      },
    })

    -- Popupmenu view configuration
    opts.views.popupmenu = vim.tbl_deep_extend("force", opts.views.popupmenu or {}, {
      border = {
        style = POPUP_BORDER,
      },
      win_options = {
        winblend = 0,
      },
    })

    -- Confirm view (y/n prompts) configuration
    opts.views.confirm = vim.tbl_deep_extend("force", opts.views.confirm or {}, {
      border = {
        style = POPUP_BORDER,
      },
      win_options = {
        winblend = 0,
      },
    })

    -- Hover view (K): give it the same bordered chrome as goto-preview instead
    -- of the default borderless float, so the two look like one popup family.
    -- max_width/max_height are capped at 60% of the editor so a long doc
    -- comment can't spill past the code column into the sidebar (noice's
    -- `size` fields are plain column/row counts, not percentages -- see
    -- noice/util/nui.lua's get_layout(), which has no "%"-string handling
    -- for `popup` views outside `position`). Recomputed on VimResized since
    -- get_layout() re-reads this same table live on every popup open.
    opts.views.hover = vim.tbl_deep_extend("force", opts.views.hover or {}, {
      border = {
        style = POPUP_BORDER,
        padding = { 0, 2 },
      },
      size = {
        width = "auto",
        height = "auto",
        max_width = math.floor(vim.o.columns * 0.6),
        max_height = math.floor(vim.o.lines * 0.6),
      },
      win_options = {
        winblend = 0,
      },
    })

    -- Writing the new cap into Config.options.views.hover alone is not enough:
    -- noice's View.get_view() (noice/view/init.lua) memoizes one NuiView
    -- instance per view name the first time it's shown, keyed by a deep-equal
    -- check against the opts it was built with. Once the hover popup has been
    -- opened once, that cached view's own self._opts/self._view_opts hold a
    -- frozen copy of `size` from construction time -- update_options() (see
    -- noice/view/nui.lua) only ever re-derives from self._opts, never from
    -- Config.options again, so a resize-after-first-hover was silently
    -- ignored until this patched the live instance directly too.
    local function resize_hover_cap()
      local max_width = math.floor(vim.o.columns * 0.6)
      local max_height = math.floor(vim.o.lines * 0.6)

      local hover_cfg = require("noice.config").options.views.hover
      hover_cfg.size.max_width = max_width
      hover_cfg.size.max_height = max_height

      local ok, NoiceView = pcall(require, "noice.view")
      if not ok then
        return
      end
      for _, entry in ipairs(NoiceView._views) do
        if entry.opts and entry.opts.view == "hover" then
          for _, opts_table in ipairs({ entry.view._opts, entry.view._view_opts }) do
            if opts_table and opts_table.size then
              opts_table.size.max_width = max_width
              opts_table.size.max_height = max_height
            end
          end
        end
      end
    end

    vim.api.nvim_create_autocmd("VimResized", {
      group = vim.api.nvim_create_augroup("noice_hover_width_cap", { clear = true }),
      callback = resize_hover_cap,
    })

    -- NoiceCmdlinePopupBorder/NoiceConfirmBorder default-link to
    -- DiagnosticSignInfo upstream (lua/noice/config/highlights.lua), which
    -- clashes with the FloatBorder color everything else (including
    -- goto-preview) uses. Re-point them after noice registers its defaults.
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("noice_unify_popup_border", { clear = true }),
      callback = function()
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { link = "FloatBorder" })
        vim.api.nvim_set_hl(0, "NoiceConfirmBorder", { link = "FloatBorder" })
      end,
    })
  end,
}
