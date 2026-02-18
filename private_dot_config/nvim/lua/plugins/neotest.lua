return {
  "nvim-neotest/neotest",
  enabled = false, -- Disabled due to compatibility issues with this project's build.sbt
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "stevanmilic/neotest-scala", -- Scala adapter for neotest
  },
  keys = {
    {
      "<leader>tt",
      function()
        require("neotest").run.run()
      end,
      desc = "Run nearest test",
    },
    {
      "<leader>tf",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run test file",
    },
    {
      "<leader>td",
      function()
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "Debug nearest test",
    },
    {
      "<leader>ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle test summary",
    },
    {
      "<leader>to",
      function()
        require("neotest").output.open({ enter = true })
      end,
      desc = "Show test output",
    },
    {
      "<leader>tp",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "Toggle test output panel",
    },
    {
      "<leader>tS",
      function()
        require("neotest").run.stop()
      end,
      desc = "Stop nearest test",
    },
    {
      "<leader>ta",
      function()
        require("neotest").run.attach()
      end,
      desc = "Attach to nearest test",
    },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-scala")({
          -- Neotest-scala configuration
          runner = "sbt", -- or "bloop" if you use Bloop
          framework = "scalatest", -- or "munit", "utest"
        }),
      },
      -- Optional: Configure test discovery
      discovery = {
        enabled = true,
        concurrent = 1,
      },
      -- Optional: Configure output
      output = {
        enabled = true,
        open_on_run = "short",
      },
      -- Optional: Configure diagnostic messages
      diagnostic = {
        enabled = true,
        severity = vim.diagnostic.severity.ERROR,
      },
      -- Optional: Configure floating windows
      floating = {
        border = "rounded",
        max_height = 0.6,
        max_width = 0.6,
        options = {},
      },
      -- Optional: Configure icons
      icons = {
        passed = "",
        running = "",
        failed = "",
        skipped = "",
        unknown = "",
      },
      -- Optional: Configure status signs
      status = {
        enabled = true,
        virtual_text = false,
        signs = true,
      },
    })
  end,
}
