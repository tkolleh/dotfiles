local nvim_lsp = require'nvim_lsp'
local api = vim.api
local fn = vim.fn

-- Setup Nvim LSP configuration(s) with default values. Configure buffer(s)
-- omnifunc handler to consume LSP completion for each filetype, configuring
-- diagnostic-nvim in the process.

local on_attach_callback = function(_, bufnr)
  api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  require'diagnostic'.on_attach()
end

local servers = {'pyls_ms', 'sumneko_lua', 'tsserver', 'vimls', 'ocamllsp', 'html', 'sqlls'}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach_callback,
  }
end


-- Change default signcolumn signs for LSP
-- ~~note that the following is done this way as a reminder of the different ways to utilize nvim
api.nvim_call_function('sign_define', {"LspDiagnosticsErrorSign", {text = "", texthl = "LspDiagnosticsError"}})

fn.sign_define("LspDiagnosticsWarningSign", {text = "", texthl = "LspDiagnosticsWarning"})
fn.sign_define("LspDiagnosticsInformationSign", {text = "", texthl = "LspDiagnosticsInformation"})
fn.sign_define("LspDiagnosticsHintSign", {text = "", texthl = "LspDiagnosticsHint"})
