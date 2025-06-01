return {
  "mfussenegger/nvim-dap",
  opts = function()
    -- Debug settings
    local dap = require("dap")
    dap.configurations.scala = {
      {
        type = "scala",
        request = "launch",
        name = "Run or test",
        metals = {
          runType = "runOrTestFile",
        },
      },
      {
        type = "scala",
        request = "launch",
        name = "Run or test w/ args",
        metals = {
          runType = "runOrTestFile",
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " +")
          end,
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
      {
        type = "scala",
        request = "attach",
        name = "Attach to Localhost",
        hostName = "localhost",
        port = 5005,
        buildTarget = "root",
      }
    }
  end,
}
