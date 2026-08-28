local function fzf_pick_chezmoi()
  local fzf = require("fzf-lua")
  local chezmoi = require("chezmoi.commands")

  fzf.fzf_exec(chezmoi.list(), {
    prompt = "Chezmoi ❯ ",
    -- Correct way to disable your global "path.filename_first" override
    -- so Fzf-Lua passes the raw, unformatted string.
    formatter = false,
    actions = {
      ["default"] = function(selected)
        if not selected or not selected[1] then
          return
        end
        -- 1. Extract the raw path using fzf-lua's parser
        local file = require("fzf-lua.path").entry_to_file(selected[1]).path
        -- 2. Strictly trim any trailing standard spaces or non-breaking spaces
        local clean_path = vim.trim(file:gsub("[%s ]+$", ""))
        -- 3. Construct the absolute path (e.g., ~/.zsh_aliases)
        local target_path = vim.env.HOME .. "/" .. clean_path
        -- 4. Pass the exact, pristine absolute path to chezmoi.nvim
        chezmoi.edit({
          targets = { target_path },
        })
      end,
    },
  })
end

return {
  "xvzc/chezmoi.nvim",
  cmd = { "ChezmoiEdit" },
  keys = {
    {
      "<leader>fz",
      fzf_pick_chezmoi,
      desc = "Chezmoi",
    },
  },
  opts = {
    edit = {
      watch = false,
      force = false,
    },
    notification = {
      on_open = true,
      on_apply = true,
      on_watch = false,
    },
    telescope = {
      select = { "<CR>" },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = { vim.env.HOME .. "/.local/share/chezmoi/*" },
      callback = function()
        vim.schedule(require("chezmoi.commands.__edit").watch)
      end,
    })
  end,
}
