return {
  "sudo-tee/opencode.nvim",
  enabled = false,
  opts = {
    preferred_picker = "fzf", -- 'telescope', 'fzf', 'mini.pick', 'snacks', 'select', if nil, it will use the best available picker. Note mini.pick does not support multiple selections
    default_global_keymaps = false, -- If false, disables all default global keymaps
    default_mode = "plan", -- 'build' or 'plan' or any custom configured. @see [OpenCode Agents](https://opencode.ai/docs/modes/)
    opencode_executable = "opencode", -- Name of your opencode binary
  },
  config = function(_, opts)
    require("opencode").setup(opts)
  end,
}
