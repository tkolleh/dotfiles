-- Extends LazyVim's bundled conform.nvim defaults (lua/fish/sh only; see
-- lazyvim/plugins/formatting.lua) with inflow for prose filetypes. inflow
-- only affects `gq`/manual formatprg use via its own install docs; wiring it
-- here additionally gives format-on-save (gated by vim.g.autoformat) and
-- <leader>cf, both of which are independent of the prose_textwidth autocmd's
-- live-wrap behavior (see autocmds.lua) -- formatprg/formatexpr never enter
-- conform's dispatch path, so there's no interaction to guard against there.
--
-- Guarded on executable("inflow") since the binary isn't installed by Mason;
-- see https://github.com/stephen-huan/inflow for install options (Nix flake
-- or `pip install python-inflow`).
return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    if vim.fn.executable("inflow") == 1 then
      local prose_filetypes = { "markdown", "text", "gitcommit", "asciidoc" }

      opts.formatters = opts.formatters or {}
      opts.formatters.inflow = {
        command = "inflow",
        args = function(_, ctx)
          local width = vim.bo[ctx.buf].textwidth
          return { tostring(width > 0 and width or 100) }
        end,
        stdin = true,
      }

      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(prose_filetypes) do
        opts.formatters_by_ft[ft] = { "inflow" }
      end
    end
    return opts
  end,
}
