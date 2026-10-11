-- AsciiDoc support: treesitter grammar (not yet in nvim-treesitter's core list)
-- registered via the documented "Adding custom languages" mechanism.
--
-- Uses cathaysia/tree-sitter-asciidoc, not cpkio/tree-sitter-asciidoc (the one
-- surfaced by most search results): cpkio's glue plugin also calls the
-- pre-rewrite `get_parser_configs()` API that current nvim-treesitter removed,
-- but more importantly its grammar itself fails 30/31 of its own committed
-- test corpus against tree-sitter-cli 0.27 (verified via `tree-sitter test` in
-- a scratch clone) -- even `= Title` alone produces ERROR nodes. cathaysia's
-- is an independent implementation: 54/54 own tests pass, parses real
-- documents with zero ERROR nodes, ships grammar.json + highlights.scm +
-- injections.scm, and backs the working zed-asciidoc extension.
return {
  "nvim-treesitter/nvim-treesitter",
  init = function()
    vim.filetype.add({ extension = { asciidoc = "asciidoc" } })

    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = function()
        require("nvim-treesitter.parsers").asciidoc = {
          install_info = {
            url = "https://github.com/cathaysia/tree-sitter-asciidoc",
            branch = "master",
            location = "tree-sitter-asciidoc",
            -- repo root queries/ is a directory of symlinks into the two
            -- sub-crates' own queries/ dirs (cargo workspace layout); point
            -- straight at the real one, since nvim-treesitter's copy logic
            -- can't follow the nested symlink (ENOTSUP).
            queries = "tree-sitter-asciidoc/queries",
          },
        }
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "asciidoc",
      group = vim.api.nvim_create_augroup("asciidoc_treesitter", { clear = true }),
      callback = function(ev)
        pcall(vim.treesitter.start, ev.buf, "asciidoc")
      end,
    })
  end,
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, { "asciidoc" })
    return opts
  end,
}
