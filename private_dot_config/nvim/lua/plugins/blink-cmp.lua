return {
  "saghen/blink.cmp",
  -- minuet-ai.nvim is NOT listed under `dependencies` here: that would force
  -- lazy.nvim to load it as a prerequisite every time blink.cmp loads (its
  -- own extra-spec event is InsertEnter/CmdlineEnter), defeating the
  -- `<leader>ae`/`:MinuetEnable` deferral set up in minuet-ai.lua. The two
  -- plugins only need to agree at runtime via `vim.g.minuet_enabled`, not via
  -- a load-order dependency.
  opts = function(_, opts)
    -- blink.cmp's signature help is confirmed broken: sources.get_signature_help()
    -- returns empty even when the attached LSP (vtsls) responds with a valid
    -- signatureHelp result. noice.nvim's hijacked vim.lsp.buf.signature_help
    -- (bound to <C-k> insert / gK normal by LazyVim) works correctly, so let
    -- it own this capability instead. Remove blink's own <C-k> binding --
    -- it's applied unconditionally regardless of signature.enabled, and would
    -- otherwise shadow LazyVim's <c-k> LSP keymap with an inert no-op.
    opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
      ["<C-k>"] = false,
      -- `require("minuet")` must NOT happen here: this `opts` function runs
      -- once, eagerly, the moment blink.cmp itself loads (InsertEnter), so
      -- calling `make_blink_map()` at this scope -- even guarded by
      -- `vim.g.minuet_enabled` -- would still `require("minuet")` on every
      -- session and reintroduce the eager-load bug. Deferred to inside the
      -- mapping function instead, which only runs when <A-y> is actually
      -- pressed, by which point minuet-ai.nvim may legitimately be loaded.
      ["<A-y>"] = {
        function(cmp)
          if not vim.g.minuet_enabled then
            vim.notify("minuet-ai: not enabled -- run :MinuetEnable or <leader>ae first", vim.log.levels.WARN)
            return
          end
          return require("minuet").make_blink_map()[1](cmp)
        end,
      },
    })

    -- `minuet` stays out of `opts.sources.default`'s static list and is appended
    -- only by this function, re-run on every completion request (blink's
    -- sources/lib/init.lua: get_enabled_provider_ids calls config.sources.default()
    -- live, never memoizes it). Providers are themselves only constructed --
    -- which is what actually does `require("minuet.blink")` and pulls in
    -- minuet-ai.nvim (provider/init.lua source.new()) -- the first time
    -- get_provider_by_id requests that id, so until `:MinuetEnable` flips
    -- vim.g.minuet_enabled, "minuet" never appears in the enabled id list and
    -- the provider (and the plugin behind it) is never touched.
    local base_default = vim.deepcopy(opts.sources.default or {})
    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      default = function()
        if vim.g.minuet_enabled then
          return vim.list_extend(vim.deepcopy(base_default), { "minuet" })
        end
        return base_default
      end,
      providers = {
        minuet = {
          name = "minuet",
          module = "minuet.blink",
          async = true,
          timeout_ms = 3000,
          score_offset = 50,
        },
      },
    })

    return opts
  end,
}
