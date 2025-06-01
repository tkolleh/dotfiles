return {
  "scalameta/nvim-metals",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = { "scala", "sbt", "sc", "java" },
  keys = {
    {
      "<leader>me",
      function()
        require("telescope").extensions.metals.commands()
      end,
      desc = "Metals commands",
    },
    {
      "<leader>mc",
      function()
        require("metals").compile_cascade()
      end,
      desc = "Metals compile cascade",
    },
    {
      "<leader>mh",
      function()
        require("metals").hover_worksheet()
      end,
      desc = "Metals hover worksheet",
    },
  },
  opts = function(_, opts)
    local metals = require("metals")
    local metals_config = vim.tbl_deep_extend("force", metals.bare_config(), opts)
    metals_config.on_attach = function(client, bufnr)
      LazyVim.has("nvim-dap")
      metals.setup_dap()
    end
    metals_config.settings = {
      showImplicitArguments = true,
      excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      javaHome = "/Users/tj.kolleh/Library/Caches/Coursier/arc/https/corretto.aws/downloads/resources/17.0.14.7.1/amazon-corretto-17.0.14.7.1-macosx-aarch64.tar.gz/amazon-corretto-17.jdk/Contents/Home",
      superMethodLensesEnabled = true,  -- [default:false] Super method lenses are visible
      verboseCompilation = true,        -- [default:false] Show all possible debug information
      defaultBspToBuildTool = true,    -- [default:false] If build tool serves as build server, use it
      bloopSbtAlreadyInstalled = false, -- [default:false] Metals will not generate metals.sbt
      bloopJvmProperties = { "-Xmx1G" },
      serverProperties = { "-Xmx3g", "-Xms1G" },
      serverVersion = "latest.snapshot",
    }
    -- *READ THIS*
    -- "off" will enable LSP progress notifications by Metals and you'll need
    -- to ensure you have a plugin like fidget.nvim installed to handle them.
    --
    -- "on" will enable the custom Metals status extension and you *have* to have
    -- a have settings to capture this in your statusline or else you'll not see
    -- any messages from metals. There is more info in the help docs about this
    metals_config.init_options.statusBarProvider = "off"
    return metals_config
  end,
  config = function(self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = self.ft,
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end,
}
