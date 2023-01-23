local M = {}

M.config = function()
  lvim.builtin.dap.on_config_done = function(dap)
    dap.configurations.scala = {
      {
        type = "scala",
        request = "launch",
        name = "RunOrTest",
        metals = {
          runType = "runOrTestFile",
          --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
          -- jvmOptions = { "-Dpropert=123" },
          -- env = {}, -- Environment variables
          envFile = ".env",
        },
      },
      {
      type = "scala",
      request = "launch",
      name = "Run",
      metals = {
        runType = "run"
      }
    },
    {
      type = "scala",
      request = "launch",
      name = "Test File",
      metals = {
        runType = "testFile"
      }
    },
    {
      type = "scala",
      request = "launch",
      name = "Test Target",
      metals = {
        runType = "testTarget"
      }
    },
  }
  -- Setup dap UI
  local dapui = require('dapui')

  -- Use nvim-dap events to open and close the dapui automatically
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  -- dap.listeners.before.event_terminated["dapui_config"] = function()
  --   dapui.close()
  -- end
  -- dap.listeners.before.event_exited["dapui_config"] = function()
  --   dapui.close()
  -- end
  dap.listeners.after["event_terminated"]["nvim-metals"] = function()
    vim.notify("Tests have finished!")
    dap.repl.open()
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

  --  dap and dapui keybindings
  lvim.builtin.which_key.mappings["dv"] = { "<cmd>lua require 'dapui'.toggle()<cr>", "Toggle Sidebar" }
  lvim.builtin.which_key.mappings["de"] = { "<cmd>lua require 'dapui'.eval()<cr>", "Evaluate" }
  lvim.builtin.which_key.mappings["dl"] = {
    "<cmd>lua require 'telescope'.extensions.dap.list_breakpoints{}<cr>",
    "list breakpoints"
  }
end


M.dap_status = function()
  local conditions = require("lvim.core.lualine.conditions")
  local ds = require("dap").status()
  local status = {
    ds,
    icon = "🦟",
    color = { gui = "bold" },
    cond = conditions.hide_in_width,
  }
  return status
end

return M
