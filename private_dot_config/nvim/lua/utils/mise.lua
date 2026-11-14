local M = {}

local CONFIG_FILES = { "mise.toml", ".mise.toml", "mise.local.toml", ".mise.local.toml" }

-- `mise env --json` prints every [env] value, secrets included; forward only what Metals needs.
local FORWARDED = { "PATH", "JAVA_HOME", "METALS_JAVA_HOME", "SBT_OPTS" }

local TIMEOUT_MS = 5000

---@param cmd string[]
---@param cwd string
---@return string|nil stdout
---@return string|nil err
local function run(cmd, cwd)
  -- vim.system raises (rather than returning a code) when the executable is missing.
  local ok, res = pcall(function()
    return vim.system(cmd, { cwd = cwd, text = true }):wait(TIMEOUT_MS)
  end)
  if not ok then
    return nil, tostring(res)
  end
  if res.code ~= 0 then
    return nil, vim.trim(res.stderr ~= "" and res.stderr or res.stdout)
  end
  return res.stdout
end

---Nearest ancestor of `dir` holding a mise config, never searching above the git root so a stray
---config in a parent directory cannot turn unrelated projects into mise projects.
---@param dir string
---@return string|nil
function M.root(dir)
  local repo = vim.fs.root(dir, ".git")
  local found = vim.fs.find(CONFIG_FILES, {
    path = dir,
    upward = true,
    limit = 1,
    stop = vim.fs.dirname(repo or dir),
  })[1]
  return found and vim.fs.dirname(found) or nil
end

---@param root string
---@return table<string, string>|nil env subset of `mise env --json`
---@return string|nil err why mise could not be consulted (missing, untrusted, malformed output)
function M.env(root)
  local out, err = run({ "mise", "env", "--json" }, root)
  if not out then
    return nil, err
  end
  local ok, decoded = pcall(vim.json.decode, out, { luanil = { object = true, array = true } })
  if not ok or type(decoded) ~= "table" then
    return nil, "unparseable `mise env --json` output"
  end
  return vim.iter(FORWARDED):fold({}, function(acc, key)
    if type(decoded[key]) == "string" then
      acc[key] = decoded[key]
    end
    return acc
  end)
end

---Real binary path (not the shim) so the project's pinned version is what runs.
---@param tool string
---@param root string
---@return string|nil
function M.which(tool, root)
  local out = run({ "mise", "which", tool }, root)
  local path = out and vim.split(out, "\n", { trimempty = true })[1]
  return path and vim.trim(path) or nil
end

return M
