local M={}

M.config = function ()
  local builtin_opts = lvim.builtin.treesitter
  -- if you don't want all the parsers change this to a table of the ones you want
  if type(builtin_opts.ensure_installed) == 'table' then
    vim.list_extend(builtin_opts.ensure_installed, {
      'bash',
      'c',
      'javascript',
      'json',
      'lua',
      'python',
      'typescript',
      'css',
      'rust',
      'java',
      'yaml',
      'scala',
      'sql',
      'query',
      'dockerfile',
      'jsdoc',
      'make',
      'toml',
      'help',
    })
  end
  if type(builtin_opts.ignore_install) == 'table' then
    vim.list_extend(builtin_opts, { 'vimdoc', 'ocaml'})
  end
  builtin_opts.highlight.enabled = true
  builtin_opts.playground.enable = true
  builtin_opts.on_config_done = function(config)
    config.setup {
      matchup = {
        -- mandatory, false will disable the whole extension
        enable = true,
      },
    }
    local hocon_group = vim.api.nvim_create_augroup("hocon", { clear = true })
    vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
      group = hocon_group,
      pattern = '*/resources/*.conf',
      command = 'set ft=hocon'
    })
  end
end

return M
