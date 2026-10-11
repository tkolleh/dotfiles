return {
  "folke/noice.nvim",
  opts = function(_, opts)
    -- Border glyphs match goto-preview's override (lua/plugins/goto-preview.lua)
    -- so noice and goto-preview floats read as one unified popup family.
    local POPUP_BORDER = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }

    -- Suppress "No information available" notify on empty LSP hover (K)
    --
    -- Signature help gets its own view name ("ck_signature", defined below
    -- under opts.views) instead of inheriting noice's default of sharing
    -- the plain K-hover view ("hover"). noice/view/init.lua's View.get_view()
    -- memoizes one NoiceView instance per view NAME and reuses it across any
    -- call whose computed opts deep_equal an existing cached entry -- two
    -- different popup kinds sharing one name are eligible to collide and
    -- freeze each other's `_opts` (border/size/anchor), which is why
    -- signature help needs a cache key of its own, never shared with hover.
    opts.lsp = vim.tbl_deep_extend("force", opts.lsp or {}, {
      hover = { silent = true },
      signature = {
        view = "ck_signature",
      },
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
    })

    -- Popupmenu view configuration (base view has no border style at all)
    opts.views.popupmenu = vim.tbl_deep_extend("force", opts.views.popupmenu or {}, {
      border = {
        style = POPUP_BORDER,
      },
    })

    -- Confirm view (y/n prompts) configuration
    opts.views.confirm = vim.tbl_deep_extend("force", opts.views.confirm or {}, {
      border = {
        style = POPUP_BORDER,
      },
    })

    -- Hover view (K): give it the same bordered chrome as goto-preview instead
    -- of the default borderless float, so the two look like one popup family.
    -- (padding {0,2} already matches hover's own base default -- not set
    -- here, only the border style changes.) max_width/max_height are capped
    -- at 60% of the editor so a long doc comment can't spill past the code
    -- column into the sidebar (noice's `size` fields are plain column/row
    -- counts, not percentages -- see noice/util/nui.lua's get_layout(),
    -- which has no "%"-string handling for `popup` views outside
    -- `position`). Recomputed on VimResized since get_layout() re-reads
    -- this same table live on every popup open.
    opts.views.hover = vim.tbl_deep_extend("force", opts.views.hover or {}, {
      border = {
        style = POPUP_BORDER,
      },
      size = {
        max_width = math.floor(vim.o.columns * 0.6),
        max_height = math.floor(vim.o.lines * 0.6),
      },
    })

    -- Dedicated signature-help view, chained to "hover" (`view = "hover"`
    -- walks noice/config/views.lua's `M.get_options` inheritance pointer, so
    -- this still gets hover's backend="popup"/win_options/border base) but
    -- registered under its own cache key so it never shares hover's
    -- memoized NoiceView instance (see the comment on `opts.lsp` above).
    --
    -- `anchor = "SW"` + negative `position.row` pin the float's bottom-left
    -- corner above the cursor and grow upward, rather than noice's default
    -- `anchor = "auto"`, which picks "grow down over the cursor" almost
    -- anywhere except the very bottom of the terminal (noice/util/nui.lua
    -- Util.nui.anchor picks N whenever popup height < remaining window rows
    -- below the cursor). A static anchor is never revisited: every write to
    -- `self._opts.anchor` in noice/view/nui.lua's NuiView:update_options
    -- lives inside `if self._opts.anchor == "auto"`.
    --
    -- max_height is a percentage of the rows actually available ABOVE the
    -- cursor (`vim.fn.winline() - 1`), not of `vim.o.lines`: since this view
    -- always grows upward, a long signature (e.g. a full JSDoc comment) can
    -- exceed the cursor's real headroom even when well within some flat
    -- fraction of the whole window. Capping against actual headroom means
    -- the popup can never grow taller than the space it's growing into,
    -- while still scaling with the terminal like a percentage should.
    -- nui's scrollbar (on by default for the "popup" backend) handles
    -- content taller than the cap via scroll rather than overflow.
    --
    -- Recomputed per-keystroke, not just on resize -- see
    -- `resize_popup_caps` below -- since cursor row is what usually changes
    -- this value, not window size.
    opts.views.ck_signature = {
      view = "hover",
      anchor = "SW",
      position = { row = -1, col = 0 },
      size = {
        max_width = math.floor(vim.o.columns * 0.6),
        max_height = math.max(1, math.floor((vim.fn.winline() - 1) * 0.8)),
      },
    }

    -- Writing new caps into Config.options.views.{hover,ck_signature} alone
    -- isn't enough once a popup has already been shown: View.get_view()
    -- memoizes one NuiView instance per view name, and that cached
    -- instance's own self._opts/self._view_opts hold a frozen copy of
    -- `size` from construction time -- update_options() only ever
    -- re-derives from self._opts, never from Config.options again. This
    -- patches the live instance directly too, for both view names.
    --
    -- max_height is per-view: hover uses a flat percentage of the whole
    -- window, ck_signature uses a percentage of the room above the cursor
    -- (see the comment on `opts.views.ck_signature`).
    local function resize_popup_caps()
      local max_width = math.floor(vim.o.columns * 0.6)
      local max_heights = {
        hover = math.floor(vim.o.lines * 0.6),
        ck_signature = math.max(1, math.floor((vim.fn.winline() - 1) * 0.8)),
      }

      local noice_config = require("noice.config")
      for view_name, max_height in pairs(max_heights) do
        local view_cfg = noice_config.options.views[view_name]
        if view_cfg and view_cfg.size then
          view_cfg.size.max_width = max_width
          view_cfg.size.max_height = max_height
        end
      end

      local ok, NoiceView = pcall(require, "noice.view")
      if not ok then
        return
      end
      for _, entry in ipairs(NoiceView._views) do
        local max_height = entry.opts and max_heights[entry.opts.view]
        if max_height then
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
      callback = resize_popup_caps,
    })

    -- ck_signature's cap depends on cursor row, which VimResized never
    -- tracks. Recompute on the same events noice's own signature
    -- auto-trigger listens to (noice/lsp/signature.lua M.setup), so the
    -- live view instance's cap is fresh before update_options() next reads
    -- it for whichever line the cursor is on.
    vim.api.nvim_create_autocmd({ "CursorMovedI", "TextChangedI", "InsertEnter" }, {
      group = vim.api.nvim_create_augroup("noice_signature_height_cap", { clear = true }),
      callback = resize_popup_caps,
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
