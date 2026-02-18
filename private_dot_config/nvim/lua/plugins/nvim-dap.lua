return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "theHamsta/nvim-dap-virtual-text",
  },
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
      },
    }

    -- Zig debug adapter configuration
    -- Uses codelldb (LLDB-based debug adapter) for Zig debugging
    if not dap.adapters.codelldb then
      dap.adapters.codelldb = {
        type = "executable",
        command = "codelldb",
        -- Alternatively, use server type for older codelldb versions
        -- type = "server",
        -- port = "${port}",
        -- executable = {
        --   command = "codelldb",
        --   args = { "--port", "${port}" },
        -- },
      }
    end

    if not dap.configurations.zig then
      dap.configurations.zig = {
        {
          name = "Debug Zig",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          terminal = "integrated",
        },
        {
          name = "Debug Zig with args",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " +")
          end,
          cwd = "${workspaceFolder}",
        },
      }
    end

    -- Also configure Zig to use the same adapter for simplicity
    if not dap.adapters.zig then
      dap.adapters.zig = dap.adapters.codelldb
    end
  end,
}
