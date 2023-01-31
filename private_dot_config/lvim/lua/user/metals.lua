local M = {}

M.config = function()
  local lvim_lsp = require("lvim.lsp")
  local metals_config = require("metals").bare_config()
  metals_config.on_init = lvim_lsp.common_on_init
  metals_config.on_exit = lvim_lsp.common_on_exit
  metals_config.capabilities = lvim_lsp.common_capabilities()
  metals_config.on_attach = function(client, bufnr)
    lvim_lsp.common_on_attach(client, bufnr)
    require("metals").setup_dap()
  end
  metals_config.settings = {
    disabledMode = false,
    bloopSbtAlreadyInstalled = false,
    ammoniteJvmProperties = {
      "-Xmx2G", "-Xms256M"
    },
    superMethodLensesEnabled = true,
    showImplicitArguments = true,
    showInferredType = true,
    showImplicitConversionsAndClasses = true,
    scalafixConfigPath = ".scalafix.conf",
    excludedPackages = {
      "akka.actor.typed.javadsl",
      "com.github.swagger.akka.javadsl",
      "akka.stream.javadsl",
      "akka.http.javadsl",
    },
  }
  metals_config.init_options.statusBarProvider = false
  -- *READ THIS*
  -- I *highly* recommend setting statusBarProvider to true, however if you do,
  -- you *have* to have a setting to display this in your statusline or else
  -- you'll not see any messages from metals. There is more info in the help
  -- docs about this
  metals_config.init_options.statusBarProvider = "on"

  vim.api.nvim_create_autocmd("FileType", {
     -- NOTE: You may or may not want java included here. You will need it if you
     -- want basic Java support but it may also conflict if you are using
     -- something like nvim-jdtls which also works on a java filetype autocmd.
    pattern = { "scala", "sbt", "java" },
    callback = function()
      require("metals").initialize_or_attach(metals_config)
    end,
    -- Autocmd that will actually be in charging of starting the whole thing
    group = vim.api.nvim_create_augroup("nvim-metals", { clear = true }),
  })

  lvim.builtin.which_key.mappings["m"] = {
    name = "metals",
    c = { "<cmd>lua require('telescope').extensions.metals.commands()<cr>", "Commands"},
    w = { "<cmd>lua require('metals').hover_worksheet()<cr>", "hover Worksheet"},
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
