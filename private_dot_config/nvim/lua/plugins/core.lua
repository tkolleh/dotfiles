--
-- nvim/lua/plugins/core.lua
-- ========================================
--

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins

local utils = require("utils")

return {
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = function(_, opts)
      local routers = require("gitlinker.routers")
      return vim.tbl_deep_extend("force", opts or {}, {
        -- example: https://code.corp.creditkarma.com/ck-private/con_idl/blob/master/acquisition-context/shared/v1/acquisitionServiceBusV1.thrift#L66
        router = {
          browse = {
            ["^code%.corp%.creditkarma%.com"] = routers.github_browse,
          },
          blame = {
            ["^code%.corp%.creditkarma%.com"] = routers.github_blame,
          },
          default_branch = {
            ["^code%.corp%.creditkarma%.com"] = routers.github_default_branch,
          },
          current_branch = {
            ["^code%.corp%.creditkarma%.com"] = routers.github_current_branch,
          },
        },
      })
    end,
    keys = {
      { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
      { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
    },
  },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
  },
  -- add gruvbox theme
  { "ellisonleao/gruvbox.nvim" },

  -- add github theme
  -- Install without configuration
  { "projekt0n/github-nvim-theme", name = "github-theme" },

  -- Customize bufferline
  {
    "akinsho/nvim-bufferline.lua",
    event = "VeryLazy",
    opts = {
      options = {
        separator_style = "slant" or "padded_slant",
        always_show_bufferline = true,
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        if utils.is_background_dark() then
          utils.setDark()
        else
          utils.setLight()
        end
      end,
    },
  },
}
