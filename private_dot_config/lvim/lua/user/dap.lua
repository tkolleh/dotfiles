local M = {}

M.config = function(is_enable)
  if not is_enable then
    return
  end
  lvim.builtin.dap.active = is_enable
  -- local dap_config = require("lvim.core.dap").configurations
  -- dap_config.scala = {
  --   {
  --     type = "scala",
  --     request = "launch",
  --     name = "RunOrTest",
  --     metals = {
  --       runType = "runOrTestFile",
  --       --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
  --     },
  --   },
  --   {
  --     type = "scala",
  --     request = "launch",
  --     name = "Test Target",
  --     metals = {
  --       runType = "testTarget",
  --     },
  --   },
  -- }
  vim.api.nvim_set_keymap('n', '<F7>', [[<Cmd>lua require'dap'.continue()<CR>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<F3>', [[<Cmd>lua require'dap'.terminate()<CR>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<F4>', [[<Cmd>lua require'dap'.terminate(); require'dap'.run_last()<CR>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<F6>', [[<Cmd>lua require'dap'.pause()<CR>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<F9>', [[<Cmd>lua require'dap'.toggle_breakpoint()<CR>]], { noremap = true, silent = true })
  -- TODO: conditional breakpoints
  vim.api.nvim_set_keymap('n', '<F8>', [[<Cmd>lua require'dap'.run_to_cursor()<CR>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<F10>', [[<Cmd>lua require'dap'.step_over()<CR>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<F11>', [[<Cmd>lua require'dap'.step_into()<CR>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<F12>', [[<Cmd>lua require'dap'.step_out()<CR>]], { noremap = true, silent = true })
  -- TODO: more debug commands https://github.com/mfussenegger/nvim-dap/blob/9b8c27d6dcc21b69834fe9c2d344e49030783390/doc/dap.txt#L460
end

return M
