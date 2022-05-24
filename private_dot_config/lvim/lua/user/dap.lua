local M = {}

M.config = function()
  lvim.builtin.dap.on_config_done = function(dap)
    print("bufferline: " .. vim.inspect(dap ~= nil))
    dap.configurations.scala = {
    {
      type = "scala",
      request = "launch",
      name = "RunOrTest",
      metals = {
        runType = "runOrTestFile",
        --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
      },
    },
    {
      type = "scala",
      request = "launch",
      name = "Test Target",
      metals = {
        runType = "testTarget",
      },
    },
  }
  -- Setup dap UI
  local dapui = require('dapui')
  dapui.setup()

  -- Use nvim-dap events to open and close the dapui automatically
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  end

  -- Autocomplete repl commands, see :h dap-completion
   local nvim_dap_group = vim.api.nvim_create_augroup("nvim-dap", { clear = true })
   vim.api.nvim_create_autocmd("FileType", {
     pattern = { "dap-repl" },
     callback = function()
       require('dap.ext.autocompl').attach()
     end,
     group = nvim_dap_group,
   })

  --  dapui keybindings
  lvim.builtin.which_key.mappings["dv"] = { "<cmd>lua require 'dapui'.toggle()<cr>", "Toggle Sidebar" }
  lvim.builtin.which_key.mappings["de"] = { "<cmd>lua require 'dapui'.eval()<cr>", "Evaluate" }
end

return M
