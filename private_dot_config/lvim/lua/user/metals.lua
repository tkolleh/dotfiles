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
    showImplicitArguments = true,
    showInferredType = true,
    ammoniteJvmProperties = {
      "-Xmx2G", "-Xms256M"
    },
    excludedPackages = {},
  }
  metals_config.init_options.statusBarProvider = "on"
  require("metals").initialize_or_attach { metals_config }
end

return M
