return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  -- Forces trouble.nvim to load before this opts function runs -- the trouble
  -- component below require()s it directly, and it has no event trigger of
  -- its own (only cmd="Trouble"/keys), so without this, VeryLazy can fire
  -- before trouble is on the runtimepath, intermittently aborting this opts
  -- function before lualine.setup() ever runs.
  --
  -- minuet-ai.nvim is deliberately NOT listed here: it's now deferred behind
  -- `<leader>ae`/`:MinuetEnable` (minuet-ai.lua), and pulling it in via
  -- `dependencies` would force-load it on every session again, same as the
  -- eager-load bug fixed in blink-cmp.lua's sources config. The `pcall` below
  -- already handles minuet-ai.nvim not being on the runtimepath yet.
  dependencies = { "folke/trouble.nvim" },
  opts = function(_, opts)
    local metals_status = {
      function()
        return vim.g.metals_status or ""
      end,
      cond = function()
        return (vim.g.metals_status or "") ~= ""
      end,
      color = function()
        return { fg = Snacks.util.color("DiagnosticInfo") }
      end,
    }

    -- LSP progress is handled by noice.nvim
    table.insert(opts.sections.lualine_x, 1, metals_status)

    -- Shows a spinner + provider:model + request count while a minuet-ai completion
    -- request is in flight (driven by minuet's own MinuetRequestStartedPre/Started/
    -- Finished User autocmds). pcall-guarded as defense-in-depth (e.g. plugin disabled
    -- via LazyVim's enabled=false) on top of the dependencies field above, which is
    -- what actually guarantees load order.
    local minuet_ok, minuet_lualine = pcall(require, "minuet.lualine")
    if minuet_ok then
      table.insert(opts.sections.lualine_x, 1, { minuet_lualine })
    end

    -- Live count of open lsp_document_symbols items in trouble.nvim; self-refreshes
    -- lualine via trouble's own on_update listener (trouble/api.lua) when the list changes.
    -- trouble.statusline() returns {has = fun():boolean, get = fun():string}, NOT a
    -- lualine component itself (confirmed in trouble/api.lua's own return annotation) --
    -- it must be wrapped as {get, cond = has}, a bare function in position 1 plus a
    -- cond. Inserting the raw {has, get} table directly made lualine's draw_section
    -- call component:draw() on a malformed entry, which returned nil and crashed
    -- lualine's refresh with "attempt to get length of a nil value" (section.lua:39),
    -- aborting the whole statusline render -- this, not the load-order issue the
    -- dependencies field above fixes, was the actual cause of the blank statusline.
    local trouble_ok, trouble_statusline = pcall(function()
      return require("trouble").statusline({
        mode = "lsp_document_symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{count}",
        hl_group = "lualine_c_normal",
      })
    end)
    if trouble_ok then
      table.insert(opts.sections.lualine_x, 1, { trouble_statusline.get, cond = trouble_statusline.has })
    end
  end,
}
