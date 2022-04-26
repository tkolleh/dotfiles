local M = {}

M.config = function()
  local metals_config = require("metals").bare_config()
  metals_config.on_attach = require("lvim.lsp").common_on_attach
  metals_config.root_patterns = {
    "build.sbt",
    "build.sc",
    "build.gradle",
    "pom.xml",
    ".scala-build",
  }
  metals_config.settings = {
    ammoniteJvmProperties = {
      "-Xmx2G", "-Xms256M"
    },
    bloopJvmProperties = { "-Xss8m" },
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
  metals_config.init_options.statusBarProvider = "on"

  require("metals").initialize_or_attach { metals_config }


  lvim.builtin.which_key.mappings["m"] = {
    name = "metals",
    c = { "<cmd>lua require('telescope').extensions.metals.commands()", "Commands"},
    w = { "<cmd>lua require('metals').hover_worksheet()", "Worksheet"},
    t = { "<cmd>lua require('metals.tvp').toggle_tree_view()", "Tree view"},
    r = { "<cmd>lua require('metals.tvp').reveal_in_tree()", "Reveal in tree"},
    s = { "<cmd>lua require('metals').toggle_setting('showImplicitArguments')", "Show implicit arguments"},
  }
end

return M
