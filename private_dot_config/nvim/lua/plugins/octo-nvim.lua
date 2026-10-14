return {
  enabled = false,
  "pwntester/octo.nvim",
  cmd = "Octo",
  event = { { event = "BufReadCmd", pattern = "octo://*" } },
  opts = {
    enable_builtin = true,
    default_to_projects_v2 = false,
    default_merge_method = "squash",
    picker = "fzf-lua",
    suppress_missing_scope = {
      projects_v2 = true,
    },
  },
}
