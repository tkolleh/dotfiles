local dap = require('dap')

vim.fn.sign_define('DapBreakpoint', {text='', texthl='error', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='⟿', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='⟼', texthl='warning', linehl='debugPC', numhl=''})


-- virtual text for dap, plugin configuration
vim.g.dap_virtual_text = false -- virtual text deactivated (default)
vim.g.dap_virtual_text = true -- show virtual text for current frame (recommended)
vim.g.dap_virtual_text = 'all frames' -- request variable values for all frames (experimental)


-- Dap Configuration(s) ------------------------- 

dap.adapters.python = {
  type = 'executable';
  command = os.getenv('HOME') .. '/.config/coc-python';
  args = { '-m', 'debugpy.adapter' };
}
dap.configurations.python = {
  {
    type = 'python';
    request = 'launch';
    name = "Launch python file";
    program = "${file}";
    -- console = "integratedTerminal"; -- requires https://github.com/neovim/neovim/pull/11839
    pythonPath = function()
      local cwd = vim.fn.getcwd()
      local conda = os.getenv('HOME') .. '/.config/coc-python'
      if string.len(conda) then
        return conda
      elseif vim.fn.executable(cwd .. '/venv/bin/python') then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') then
        return cwd .. '/.venv/bin/python'
      else
        return '/usr/bin/python'
      end
    end;
  },
}

