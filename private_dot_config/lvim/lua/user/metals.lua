local M = {}

M.config = function()
  local metals_config = require("metals").bare_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
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
  metals_config.init_options.statusBarProvider = "on"

  metals_config.on_attach = function(client, bufnr)
    require("metals").setup_dap()
  end

  -- Autocmd that will actually be in charging of starting the whole thing
  local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    -- NOTE: You may or may not want java included here. You will need it if you
    -- want basic Java support but it may also conflict if you are using
    -- something like nvim-jdtls which also works on a java filetype autocmd.
    pattern = { "scala", "sbt", "java" },
    callback = function()
      require("metals").initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
  })

  lvim.builtin.which_key.mappings["m"] = {
    name = "metals",
    c = { "<cmd>lua require('telescope').extensions.metals.commands()<cr>", "Commands"},
    w = { "<cmd>lua require('metals').hover_worksheet()<cr>", "Worksheet"},
    t = { "<cmd>lua require('metals.tvp').toggle_tree_view()<cr>", "Tree view"},
    r = { "<cmd>lua require('metals.tvp').reveal_in_tree()<cr>", "Reveal in tree"},
    s = { "<cmd>lua require('metals').toggle_setting('showImplicitArguments')<cr>", "Show implicit arguments"},
  }
end

return M
