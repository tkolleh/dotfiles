local function get_java_home()
  return os.getenv("METALS_JAVA_HOME") or os.getenv("JAVA_HOME") or ""
end

local utils = require("utils")

return {
  "scalameta/nvim-metals",
  ft = { "scala", "sc", "java", "sbt", "hocon"},
  keys = {
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
        require("telescope").extensions.metals.commands()
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
  },
  opts = function(_, opts)
    local metals = require("metals")
    local metals_config = vim.tbl_deep_extend("force", metals.bare_config(), opts)
    metals_config.on_attach = function(client, bufnr)
      LazyVim.has("nvim-dap")
      metals.setup_dap()
    end
    metals_config.settings = {
      javaHome = get_java_home(),
      showImplicitArguments = false,
      enableSemanticHighlighting = true,
      excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      superMethodLensesEnabled = true,    -- [default:false] Super method lenses are visible
      verboseCompilation = false,          -- [default:false] Show all possible debug information
      defaultBspToBuildTool = true,       -- [default:false] If build tool serves as build server, use it
      bloopSbtAlreadyInstalled = false,   -- [default:false] Metals will not generate metals.sbt
      bloopJvmProperties = { "-Xms512m" },
      serverProperties = { "-Xms1g", "-Xss16m", "-XX:+UseStringDeduplication" },
      serverVersion = "latest.snapshot",
      testUserInterface = "Test Explorer",
      startMcpServer = true,
      mcpClient = 'claude'
    }
    -- 
    -- "off" will enable LSP progress notifications by Metals and you'll need
    -- to ensure you have a plugin like fidget.nvim or nvim-lualine installed 
    -- to handle them. 
    --
    -- See: https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/components/progress.lua
    --
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
