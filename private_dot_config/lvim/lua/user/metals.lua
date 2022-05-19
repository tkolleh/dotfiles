local M = {}

M.config = function()
  vim.opt_global.shortmess:remove("F"):append("c")

  local metals_config = require("metals").bare_config()

  metals_config.root_patterns = {
    "build.sbt",
    "build.sc",
    "build.gradle",
    "pom.xml",
    ".scala-build",
  }
  metals_config.settings = {
    disabledMode = false,
    bloopSbtAlreadyInstalled = true,
    ammoniteJvmProperties = {
      "-Xmx2G", "-Xms256M"
    },
    showImplicitArguments = true,
    showImplicitConversionsAndClasses = true,
    showInferredType = true,
    excludedPackages = {
      "akka.actor.typed.javadsl",
      "com.github.swagger.akka.javadsl",
      "akka.stream.javadsl",
      "akka.http.javadsl",
    },
    fallbackScalaVersion = "2.12.15",
    serverVersion = "latest.snapshot",
  }

  -- *READ THIS*
  -- I *highly* recommend setting statusBarProvider to true, however if you do,
  -- you *have* to have a setting to display this in your statusline or else
  -- you'll not see any messages from metals. There is more info in the help
  -- docs about this
  metals_config.init_options.statusBarProvider = "on"

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

  metals_config.on_attach = function(client, bufnr)
    require("lvim.lsp").common_on_attach(client, bufnr)
    require("metals").setup_dap()
  end

  require("metals").initialize_or_attach(metals_config)

  lvim.builtin.which_key.mappings["m"] = {
    name = "metals",
    c = { "<cmd>lua require('telescope').extensions.metals.commands()<cr>", "Commands"},
    w = { "<cmd>lua require('metals').hover_worksheet()<cr>", "Worksheet"},
    t = { "<cmd>lua require('metals.tvp').toggle_tree_view()<cr>", "Tree view"},
    r = { "<cmd>lua require('metals.tvp').reveal_in_tree()<cr>", "Reveal in tree"},
    s = { "<cmd>lua require('metals').toggle_setting('showImplicitArguments')<cr>", "Show implicit arguments"},
  }

  local function metals_status()
    return vim.g["metals_status"] or ""
  end

  lvim.builtin.lualine.sections.lualine_c = {
    metals_status(),
  }

end

return M
