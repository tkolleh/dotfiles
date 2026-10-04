return {
  "saghen/blink.cmp",
  opts = {
    -- blink.cmp's signature help is confirmed broken: sources.get_signature_help()
    -- returns empty even when the attached LSP (vtsls) responds with a valid
    -- signatureHelp result. noice.nvim's hijacked vim.lsp.buf.signature_help
    -- (bound to <C-k> insert / gK normal by LazyVim) works correctly, so let
    -- it own this capability instead. Remove blink's own <C-k> binding --
    -- it's applied unconditionally regardless of signature.enabled, and would
    -- otherwise shadow LazyVim's <c-k> LSP keymap with an inert no-op.
    keymap = { ["<C-k>"] = false },
  },
}
