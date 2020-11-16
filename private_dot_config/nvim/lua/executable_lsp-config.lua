local api = vim.api
local fn = vim.fn
local lsp = vim.lsp

api.nvim_command('packadd! nvim-lspconfig')  -- If installed as a Vim "package".
api.nvim_command('packadd! completion-nvim')

local nvim_lsp = require'lspconfig'
local completion_nvim = require'completion'

-- Setup Nvim LSP configuration(s) with default values. Configure buffer(s)
-- omnifunc handler to consume LSP completion for each filetype.
--
local on_attach_callback = function(client, bufnr)
  api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  completion_nvim.on_attach(client)
end

local servers = {'pyls_ms', 'sumneko_lua', 'tsserver', 'vimls', 'ocamllsp', 'html', 'sqlls'}
for _, _lsp in ipairs(servers) do
  if _lsp ~= 'sumneko_lua' then
    nvim_lsp[_lsp].setup{
      on_attach = on_attach_callback,
    }
  else
    nvim_lsp[_lsp].setup{
      on_attach = on_attach_callback,
      settings = {
        Lua = {
          diagnostics = {
            globals = {
              'vim',
            }
          }
        }
      }
    }
  end
end

-- Configure diagnostic-nvim -------------------------
--
-- Change default signcolumn signs for LSP diagnostic. Note that the first
-- line is done this way as a reminder of the different ways to
-- interact with the nvim api from lua
--
api.nvim_call_function('sign_define', {"LspDiagnosticsSignError", {text = "", texthl = "LspDiagnosticsDefaultError"}})
fn.sign_define("LspDiagnosticsSignWarning", {text = "", texthl = "LspDiagnosticsDefaultWarning"})
fn.sign_define("LspDiagnosticsSignInformation", {text = "", texthl = "LspDiagnosticsDefaultInformation"})
fn.sign_define("LspDiagnosticsSignHintSign", {text = "", texthl = "LspDiagnosticsDefaultHint"})

-- api.nvim_command('highlight link LspDiagnosticsDefaultError Comment')
-- api.nvim_command('highlight link LspDiagnosticsDefaultWarning Comment')
api.nvim_command('highlight link LspDiagnosticsDefaultInformation Comment')
api.nvim_command('highlight link LspDiagnosticsDefaultHint Comment')

lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(
  lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {
      spacing = 4,
      prefix = '',
    },
    -- Use a function to dynamically turn signs off
    -- and on, using buffer local variables
    signs = function(bufnr, client_id)
      local ok, result = pcall(api.nvim_buf_get_var, bufnr, 'show_signs')
      -- No buffer local variable set, so just enable by default
      if not ok then
        return true
      end

      return result
    end,
    update_in_insert = true,
  }
)

-- Legacy diagnostic plugin configuration
-- api.nvim_set_var('diagnostic_trimmed_virtual_text', '32')
-- api.nvim_set_var('diagnostic_sign_priority', 20)

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
