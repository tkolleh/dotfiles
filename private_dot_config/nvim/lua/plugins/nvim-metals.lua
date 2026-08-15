local utils = require("utils")
local scala = require("languages.scala")

local LOMBOK_VERSION = "1.18.46"
local LOMBOK_CACHE_PATH = vim.fn.expand(
  "~/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/org/projectlombok/lombok/"
    .. LOMBOK_VERSION
    .. "/lombok-"
    .. LOMBOK_VERSION
    .. ".jar"
)

-- Resolved asynchronously on first load; nil until confirmed present.
local _lombok_jar = nil

local function resolve_lombok()
  -- Fast path: jar already in Coursier cache — no process spawn needed.
  local stat = vim.uv.fs_stat(LOMBOK_CACHE_PATH)
  if stat then
    _lombok_jar = LOMBOK_CACHE_PATH
    return
  end

  -- Slow path: fetch via cs asynchronously.
  vim.system(
    { "cs", "fetch", "org.projectlombok:lombok:" .. LOMBOK_VERSION },
    { text = true },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        vim.notify("[metals] lombok fetch failed:\n" .. (result.stderr or ""), vim.log.levels.WARN)
        return
      end
      local jar = vim.trim(result.stdout):match("[^\n]+$")
      if jar and vim.uv.fs_stat(jar) then
        _lombok_jar = jar
        vim.notify("[metals] lombok jar resolved: " .. jar, vim.log.levels.INFO)
      end
    end)
  )
end

resolve_lombok()

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
      if LazyVim.has("nvim-dap") then
        metals.setup_dap()
      end
    end

    local metals_gcc_config = {
      "-XX:+UseG1GC",
      "-Xms2G",
      "-Xmx8G",
      "-Xss4M",
      "-XX:+UseStringDeduplication",
    }

    metals_config.settings = {
      showImplicitArguments = false,
      enableSemanticHighlighting = true, -- re-enabled under Metals 2.0.0-M8 (see below)
      excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      superMethodLensesEnabled = true, -- [default:false] Super method lenses are visible
      verboseCompilation = false, -- [default:false] Show all possible debug information
      -- Metals 2.x is MILESTONE-only (no 2.0.0 GA as of 2026-08).
      serverVersion = "2.0.0-M8",
      -- NOTE: only applied when THIS client starts the Bloop daemon. Bloop is a
      -- single shared daemon per machine; an already-running one is adopted as-is,
      -- version and JVM flags included. Kill all daemons before verifying a change.
      bloopVersion = "2.1.1",
      -- Re-run bloopInstall when build files change, which transitively fires the
      automaticImportBuild = "all",
      defaultBspToBuildTool = false, -- [default:false] If build tool serves as build server, use it
      bloopSbtAlreadyInstalled = false, -- [default:false] Bloop config is now installed
      bloopJvmProperties = metals_gcc_config,
      serverProperties = vim.list_extend(
        vim.deepcopy(metals_gcc_config),
        vim
          .iter({
            { "-Dmetals.verbose=false" },
            _lombok_jar and { "-javaagent:" .. _lombok_jar } or {},
          })
          :flatten()
          :totable()
      ),
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
