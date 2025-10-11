local function get_java_home(version)
  -- Use Coursier to get the Java home path for a specific architecture and JVM version
  local jvm_arg = string.format("corretto:%s", version or "latest")
  local cmd = string.format('cs java-home --architecture arm64 --jvm %s', jvm_arg)
  local handle = io.popen(cmd)
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result then
      -- Remove any trailing newline
      return result:gsub("%s+$", "")
    end
  end
  return nil
end

local java_versions = {
  [8] = {
    name = "JavaSE-1.8",
    path = get_java_home("8")
  },
  [17] = {
    name = "JavaSE-17",
    path = get_java_home("17")
  },
  [21] = {
    name = "JavaSE-21",
    path = get_java_home("21")
  },
}

return {
  "mfussenegger/nvim-jdtls",
  dependencies = { "folke/which-key.nvim" },
  ft = { "java" },
  opts = {
    settings = {
      java = {
        configuration = {
          -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
          -- And search for `interface RuntimeOption`
          -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
          runtimes = {
            {
              name = java_versions[8].name,
              path = java_versions[8].path,
            },
            {
              name = java_versions[17].name,
              path = java_versions[17].path,
            },
          }
        }
      }
    }
  }
}
