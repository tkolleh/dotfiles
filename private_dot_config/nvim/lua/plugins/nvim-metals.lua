local utils = require("utils")
local scala = require("languages.scala")

local metals_keys = {
  {
    "<leader>mr",
    function()
      require("metals.tvp").reveal_in_tree()
    end,
    desc = "Reveal in TVP",
  },
  {
    "<leader>mt",
    function()
      require("metals.tvp").toggle_tree_view()
    end,
    desc = "Toggle TVP",
  },
  {
    "<leader>me",
    function()
      require("metals").commands()
    end,
    desc = "Metals commands",
  },
  {
    "<leader>mc",
    utils.compile_code,
    desc = "Metals compile cascade",
  },
  {
    "<leader>mi",
    function()
      require("metals").toggle_setting("showImplicitArguments")
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
}

for _, key in ipairs(scala.test_keys or {}) do
  table.insert(metals_keys, key)
end

return {
  "scalameta/nvim-metals",
  ft = { "scala", "sc", "java", "sbt", "hocon" },
  keys = metals_keys,
  opts = function(_, opts)
    local metals = require("metals")
    local metals_config = vim.tbl_deep_extend("force", metals.bare_config(), opts)

    metals_config.on_attach = function(client, bufnr)
      LazyVim.has("nvim-dap")
      metals.setup_dap()
    end

    local metals_gcc_config = {
      "-XX:+UseG1GC",
      "-Xms1G",
      "-Xmx6G",
      "-Xss4M",
      "-XX:+UseStringDeduplication",
    }

    metals_config.settings = {
      -- javaHome = java17_home,
      showImplicitArguments = false,
      enableSemanticHighlighting = false, -- Disabled to fix semantic tokens error
      excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      superMethodLensesEnabled = true, -- [default:false] Super method lenses are visible
      verboseCompilation = false, -- [default:false] Show all possible debug information
      defaultBspToBuildTool = false, -- [default:false] If build tool serves as build server, use it
      bloopSbtAlreadyInstalled = false, -- [default:false] Bloop config is now installed
      bloopJvmProperties = metals_gcc_config,
      serverProperties = vim.list_extend(metals_gcc_config, {
        "-Dmetals.verbose=false", -- Enable verbose logging for better diagnostics
      }),
      testUserInterface = "Test Explorer",
      startMcpServer = true,
      mcpClient = "claude",
    }
    --
    -- "off" will enable LSP progress notifications by Metals and you'll need
    -- to ensure you have a plugin like fidget.nvim or nvim-lualine installed
    -- to handle them.
    --
    -- See: https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/components/progress.lua
    --
    metals_config.init_options.statusBarProvider = "on"
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
