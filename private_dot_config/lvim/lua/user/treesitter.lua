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
    "sql",
    "query",
  }
  lvim.builtin.treesitter.ignore_install = { "ocaml" }
  lvim.builtin.treesitter.highlight.enabled = true
  lvim.builtin.treesitter.playground.enable = true
  lvim.builtin.treesitter.on_config_done = function(config)
    config.setup {
      matchup = {
        enable = true,              -- mandatory, false will disable the whole extension
        -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
        -- disable_virtual_text: do not use virtual text to highlight the virtual end of a block, for languages without explicit end markers (e.g., Python).
        -- [options]
      },
    }
  end
end

return M
