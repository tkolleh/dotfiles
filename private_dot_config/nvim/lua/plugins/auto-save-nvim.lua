
local zk_notes_pattern = vim.fn.expand("~") .. "/zettelkasten/notes/**"

return {
  "okuuva/auto-save.nvim",
  version = "*",                                                       -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
  cmd = { "ASToggle", "AutoSaveToggle" },                              -- lazy load on either command
  event = {
    "BufReadPre " .. zk_notes_pattern, -- lazy load when opening a file in the zk notes directory
    "BufNewFile " .. zk_notes_pattern, -- lazy load when creating a new file in the zk notes directory
  },
  opts = {},
  config = function(_, opts)
    require("auto-save").setup(opts)
    -- Create command alias after setup
    vim.api.nvim_create_user_command("AutoSaveToggle", "ASToggle", {
      desc = "Toggle auto-save (alias for ASToggle)",
    })
  end,
}
