local api = vim.api
local fn = vim.fn

api.nvim_command('packadd! nvim-lspconfig')  -- If installed as a Vim "package".
api.nvim_command('packadd! diagnostic-nvim')
api.nvim_command('packadd! completion-nvim')

local nvim_lsp = require'nvim_lsp'
local diagnostic_nvim = require'diagnostic'
local completion_nvim = require'completion'

-- Setup Nvim LSP configuration(s) with default values. Configure buffer(s)
-- omnifunc handler to consume LSP completion for each filetype, configuring
-- diagnostic-nvim in the process.
--
local on_attach_callback = function(client, bufnr)
  api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  diagnostic_nvim.on_attach(client)
  completion_nvim.on_attach(client)
end

local servers = {'pyls_ms', 'sumneko_lua', 'tsserver', 'vimls', 'ocamllsp', 'html', 'sqlls'}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach_callback,
  }
end

-- Configure diagnostic-nvim -------------------------
--
-- Change default signcolumn signs for LSP diagnostic. Note that the first
-- line is done this way as a reminder of the different ways to
-- interact with the nvim api from lua
--
api.nvim_call_function('sign_define', {"LspDiagnosticsErrorSign", {text = "", texthl = "LspDiagnosticsError"}})
fn.sign_define("LspDiagnosticsWarningSign", {text = "", texthl = "LspDiagnosticsWarning"})
fn.sign_define("LspDiagnosticsInformationSign", {text = "", texthl = "LspDiagnosticsInformation"})
fn.sign_define("LspDiagnosticsHintSign", {text = "", texthl = "LspDiagnosticsHint"})

-- api.nvim_command('highlight link LspDiagnosticsError Comment')
api.nvim_command('highlight link LspDiagnosticsWarning Comment')
api.nvim_command('highlight link LspDiagnosticsInformation Comment')
api.nvim_command('highlight link LspDiagnosticsHint Comment')


api.nvim_set_var('diagnostic_enable_virtual_text', 1)
api.nvim_set_var('diagnostic_virtual_text_prefix', '')
api.nvim_set_var('diagnostic_trimmed_virtual_text', '32')
api.nvim_set_var('diagnostic_sign_priority', 20)
api.nvim_set_var('diagnostic_enable_underline', 0)
api.nvim_set_var('space_before_virtual_text', 5)
api.nvim_set_var('diagnostic_insert_delay', 1)


-- Configure completion-nvim -------------------------------------------------- 
--
local completion_chain_complete_list = {
  { complete_items = { 'path'} },
  { complete_items = { 'lsp' } },
  { complete_items = { 'snippet' } },
  { complete_items = { 'buffers' } },
  { mode = { '<c-p>' } },
  { mode = { '<c-n>' } }
}
api.nvim_set_var('completion_chain_complete_list', completion_chain_complete_list)
api.nvim_set_var('completion_trigger_keyword_length', 3)
api.nvim_set_var('completion_auto_change_source', 1)
api.nvim_set_var('completion_enable_snippet', 'UltiSnips')
