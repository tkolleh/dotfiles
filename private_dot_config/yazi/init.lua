require("copy-file-contents"):setup({
	append_char = "\n",
	notification = true,
})

-- Official git plugin for yazi
-- Install using `ya pkg add yazi-rs/plugins:git`
-- git
--   * https://github.com/yazi-rs/plugins/tree/main/git.yazi
--
require("git"):setup {
	-- Order of status signs showing in the linemode
	order = 1500,
}
-- View git status of directory with a one line header 
-- Install using `ya pkg add llanosrocas/githead`
-- githead
--   * https://github.com/llanosrocas/githead.yazi#presets
--
require("githead"):setup({
  order = {
    "__spacer__",
    "branch",
    "commit",
    "__spacer__",
    "behind_ahead_remote",
    "__spacer__",
    "untracked",
    "state",
    "unstaged",
    "__spacer__",
    "staged",
  },

  show_numbers = false,

  show_branch = true,
  branch_prefix = "",
  branch_color = "#288BD2",

  always_show_commit = true,
  commit_color = "#859A00",

  show_behind_ahead_remote = true,
  behind_remote_symbol = "↓",
  ahead_remote_symbol = "↑",
  behind_remote_color = "#DC322E",
  ahead_remote_color = "#4DB6AC",

  show_state = true,
  show_state_prefix = false,
  state_symbol = "!!",
  state_color = "#B58901",

  staged_symbol = "✔",
  staged_color = "green",

  unstaged_symbol = "Δ",
  unstaged_color = "#288BD2",

  untracked_symbol = "?",
  untracked_color = "#415F65",
})
