local mise = require("utils.mise")

local M = {}

M.dap = { adapters = {}, configurations = {} }

-- Defines a adapter stub that nvim-metals will fill in dynamically.
-- This is necessary to allow nvim-dap to recognize the adapter before
-- Metals starts up and provides the actual connection details.
M.dap.adapters.base = {
  type = "server",
  host = "127.0.0.1",
  port = "${port}", -- Metals will replace this variable
}

M.dap.configurations.scala = {
  -- Note: For interactive applications (like ZIO apps that read from stdin),
  -- the "Run or test" configurations will fail with an EOFException because
  -- the background process does not have a connected stdin.
  --
  -- Workflow for Interactive Applications:
  -- 1. Open a terminal split in Neovim.
  -- 2. Launch your application with JVM debug arguments:
  --    `sbt -jvm-debug 5005 "runMain com.example.Main"`
  -- 3. Use the "Attach to Localhost" DAP configuration below to connect.
  {
    type = "scala",
    request = "launch",
    name = "Run or test",
    metals = {
      runType = "runOrTestFile",
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Run or test w/ args",
    metals = {
      runType = "runOrTestFile",
      args = function()
        local co = coroutine.running()
        vim.ui.input({ prompt = "Arguments: " }, function(input)
          coroutine.resume(co, input and vim.split(input, " +") or {})
        end)
        return coroutine.yield()
      end,
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
  {
    type = "scala",
    request = "attach",
    name = "Attach to Localhost",
    hostName = "localhost",
    port = 5005,
    buildTarget = "root",
  },
}

M.test_keys = {
  {
    "<leader>tt",
    function()
      require("metals").select_test_case()
    end,
    desc = "Select and run test case (Metals)",
    ft = { "scala", "sbt" },
  },
  {
    "<leader>ts",
    function()
      require("metals").select_test_suite()
    end,
    desc = "Select and run test suite (Metals)",
    ft = { "scala", "sbt" },
  },
  {
    "<leader>td",
    function()
      require("metals.test_explorer").dap_select_test_case()
    end,
    desc = "Debug test case (Metals)",
    ft = { "scala", "sbt" },
  },
  {
    "<leader>tD",
    function()
      require("metals.test_explorer").dap_select_test_suite()
    end,
    desc = "Debug test suite (Metals)",
    ft = { "scala", "sbt" },
  },
}

local warned = {}

---@param key string
---@param msg string
local function warn_once(key, msg)
  if not warned[key] then
    warned[key] = true
    vim.notify(msg, vim.log.levels.WARN)
  end
end

---Absolute paths named in `.bsp/sbt.json` that no longer exist. sbt writes the launcher, JDK and
---`-Dsbt.script` as version-pinned paths, so a mise bump leaves Metals launching a missing binary.
---@param bsp_root string directory containing `.bsp/`
---@return string[]
function M.stale_bsp_paths(bsp_root)
  local file = vim.fs.joinpath(bsp_root, ".bsp", "sbt.json")
  if vim.fn.filereadable(file) == 0 then
    return {}
  end
  local ok, conn = pcall(vim.json.decode, table.concat(vim.fn.readfile(file), "\n"))
  if not ok or type(conn) ~= "table" then
    return {}
  end
  return vim
    .iter(conn.argv or {})
    :map(function(arg)
      return arg:match("^%-Dsbt%.script=(.+)$") or arg
    end)
    :filter(function(path)
      return vim.startswith(path, "/") and not vim.uv.fs_stat(path)
    end)
    :totable()
end

---Per-buffer nvim-metals config. Project-local mise wins over global: inside a mise project Metals
---gets mise's JDK/sbt; elsewhere the base config (and the shell's env) is used unchanged.
---Returns a copy because nvim-metals mutates the table it is handed (settings re-nesting, root_dir).
---@param base table pristine nvim-metals config
---@param dir string directory of the buffer being attached
---@return table
function M.config_for(base, dir)
  local cfg = vim.deepcopy(base)

  local bsp_root = vim.fs.root(dir, ".bsp")
  local missing = bsp_root and M.stale_bsp_paths(bsp_root) or {}
  if #missing > 0 then
    warn_once(
      "bsp:" .. bsp_root,
      ("[metals] %s/.bsp/sbt.json points at missing paths (run `sbt bspConfig`):\n%s"):format(
        bsp_root,
        table.concat(missing, "\n")
      )
    )
  end

  local root = mise.root(dir)
  if not root then
    return cfg
  end

  local env, err = mise.env(root)
  if not env then
    warn_once(
      "mise:" .. root,
      ("[metals] mise config in %s but `mise env` failed; using the global env:\n%s"):format(root, err)
    )
    return cfg
  end

  cfg.cmd_env = vim.tbl_extend("force", cfg.cmd_env or {}, env)
  cfg.settings = cfg.settings or {}
  cfg.settings.sbtScript = mise.which("sbt", root)
  return cfg
end

return M
