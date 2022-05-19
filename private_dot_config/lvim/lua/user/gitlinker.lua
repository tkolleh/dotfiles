local M = {}

M.config = function ()
  local gitlinker = require("gitlinker")
  gitlinker.setup({
    opts = {
      -- force the use of a specific remote
      remote = nil,
      -- adds current line nr in the url for normal mode
      add_current_line_on_normal_mode = true,
      -- callback for what to do with the url
      action_callback = gitlinker.actions.copy_to_clipboard,
      -- print the url after performing the action
      print_url = true,
    },
    callbacks = {
          ["code%.corp%.creditkarma%.com"] = function(url_data)
              url_data.host = "code.corp.creditkarma.com"
              return gitlinker.hosts.get_github_type_url(url_data)
            end,
    },
    -- default mapping to call url generation with action_callback
    mappings = nil
  })
  lvim.builtin.which_key.mappings['gy'] = {
    '<cmd>lua require("gitlinker").get_buf_range_url("n", {action_callback = require"gitlinker.actions".copy_to_clipboard})<cr>',
    "Copy gitlink"
  }

  vim.api.nvim_set_keymap(
    'v',
    'gy',
    [[<cmd>lua require("gitlinker").get_buf_range_url("v", {action_callback = require"gitlinker.actions".copy_to_clipboard})<cr>]],
    { noremap = true, silent = true }
  )
end

return M
