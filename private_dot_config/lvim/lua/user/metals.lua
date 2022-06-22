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
    bloopSbtAlreadyInstalled = false,
    ammoniteJvmProperties = {
      "-Xmx2G", "-Xms256M"
    },
    showImplicitArguments = true,
    showImplicitConversionsAndClasses = true,
    showInferredType = true,
    superMethodLensesEnabled = true,
    excludedPackages = {
      "akka.actor.typed.javadsl",
      "com.github.swagger.akka.javadsl",
      "akka.stream.javadsl",
      "akka.http.javadsl",
    },
    fallbackScalaVersion = "2.12.15",
    serverVersion = "latest.snapshot",
    scalafixConfigPath = ".scalafix.conf",
    scalafixRulesDependencies = {
      "com.github.liancheng::organize-imports",
      "com.github.zio::zio-shield",
      "com.timushev::zio-magic-comments",
    },
  }

  -- *READ THIS*
  -- I *highly* recommend setting statusBarProvider to true, however if you do,
  -- you *have* to have a setting to display this in your statusline or else
  -- you'll not see any messages from metals. There is more info in the help
  -- docs about this
  metals_config.init_options.statusBarProvider = "on"

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
    metals_config.capabilities = capabilities
  end

  metals_config.on_attach = function(client, bufnr)
    require("lvim.lsp").common_on_attach(client, bufnr)
    require("metals").setup_dap()
    require("aerial").on_attach(client, bufnr)
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

M.metals_status = function()
  local conditions = require("lvim.core.lualine.conditions")
  local status = {
    "g:metals_status",
    icon = "",
    color = { gui = "bold" },
    cond = conditions.hide_in_width,
  }
  return status
end


return M
