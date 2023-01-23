local M={}

M.config = function ()
  -- if you don't want all the parsers change this to a table of the ones you want
  lvim.builtin.treesitter.ensure_installed = {
    "bash",
    "c",
    "javascript",
    "json",
    "lua",
    "python",
    "typescript",
    "css",
    "rust",
    "java",
    "yaml",
    "scala",
  }

  lvim.builtin.treesitter.ignore_install = { "ocaml" }
  lvim.builtin.treesitter.highlight.enabled = true
end

return M
