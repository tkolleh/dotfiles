local M={}

M.config = function ()
  local builtin_opts = lvim.builtin.treesitter
  -- Expand the list of installed parsers
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
      'vimdoc',
    })
  end

  if type(builtin_opts.ignore_install) == 'table' then
    vim.list_extend(builtin_opts, { 'help', 'ocaml'})
  end

  builtin_opts.on_config_done = function(config)
    config.setup {
      matchup = {
        -- mandatory, false will disable the whole extension
        enable = true,
      },
    }
  end
end

return M
