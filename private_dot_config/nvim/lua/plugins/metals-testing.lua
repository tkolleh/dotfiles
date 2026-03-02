-- Alternative test running configuration for Metals
-- This provides keybindings that work directly with Metals Test Explorer
-- without requiring neotest-scala (which has compatibility issues with complex build.sbt files)

return {
  "scalameta/nvim-metals",
  keys = {
    -- Test running with Metals Test Explorer
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
  },
}
