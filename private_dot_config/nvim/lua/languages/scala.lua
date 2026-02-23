local M = {}

M.dap = { adapters = {}, configurations = {} }

-- Defines a adapter stub that nvim-metals will fill in dynamically.
-- This is necessary to allow nvim-dap to recognize the adapter before
-- Metals starts up and provides the actual connection details.
M.dap.adapters.base = {
  type = "server",
  host = "127.0.0.1",
  port = "${port}", -- Metals will replace this variable
}

M.dap.configurations.scala = {
  -- Note: For interactive applications (like ZIO apps that read from stdin),
  -- the "Run or test" configurations will fail with an EOFException because
  -- the background process does not have a connected stdin.
  --
  -- Workflow for Interactive Applications:
  -- 1. Open a terminal split in Neovim.
  -- 2. Launch your application with JVM debug arguments:
  --    `sbt -jvm-debug 5005 "runMain com.example.Main"`
  -- 3. Use the "Attach to Localhost" DAP configuration below to connect.
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

M.test_keys = {
  {
    "<leader>tt",
    function()
      require("metals").select_test_case()
    end,
    desc = "Select and run test case (Metals)",
    ft = { "scala", "sbt" },
  },
  {
    "<leader>ts",
    function()
      require("metals").select_test_suite()
    end,
    desc = "Select and run test suite (Metals)",
    ft = { "scala", "sbt" },
  },
  {
    "<leader>td",
    function()
      require("metals.test_explorer").dap_select_test_case()
    end,
    desc = "Debug test case (Metals)",
    ft = { "scala", "sbt" },
  },
  {
    "<leader>tD",
    function()
      require("metals.test_explorer").dap_select_test_suite()
    end,
    desc = "Debug test suite (Metals)",
    ft = { "scala", "sbt" },
  },
}

return M
