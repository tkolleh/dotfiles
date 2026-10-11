return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Diagnostic virtual_text/virtual_lines display is owned entirely by
    -- utils.cycle_diagnostics_display (see options.lua's initial-state call and
    -- <leader>cD in keymaps.lua). LazyVim applies opts.diagnostics once via
    -- vim.diagnostic.config() when this plugin loads (lazyvim/plugins/lsp/init.lua),
    -- so the initial state must be set here too, or that one-time call
    -- overrides it before any cycling happens.
    local utils = require("utils")
    opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
      underline = false,
      virtual_text = false,
      virtual_lines = utils.VIRTUAL_LINES_STYLE,
    })
    opts.servers.metals = nil
    opts.setup.metals = nil

    -- Enhance jsonls to support jsonc and jsonl filetypes
    if opts.servers.jsonls then
      opts.servers.jsonls.filetypes = opts.servers.jsonls.filetypes or { "json", "jsonc", "json5" }
      table.insert(opts.servers.jsonls.filetypes, "jsonl")
    end

    -- Prose/style checking for AsciiDoc (no semantic AsciiDoc LSP exists upstream;
    -- these are grammar/style linters that happen to support the filetype)
    opts.servers.harper_ls = opts.servers.harper_ls or {}
    opts.servers.vale_ls = opts.servers.vale_ls or {}

    return opts
  end,
}
