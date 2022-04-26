--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "debug"
lvim.format_on_save = true
vim.o.timeoutlen = 700
vim.o.laststatus = 3

vim.opt_global.shortmess:remove("F")

-- code folding
vim.o.foldenable = true
vim.o.foldlevel = 2
vim.o.foldlevelstart = 50
vim.o.foldcolumn = "2"
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

-- status line (lualine)
lvim.builtin.lualine.style = "default" -- or "none"
lvim.builtin.lualine.options = {
  theme = 'material',
}


-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "css",
  "rust",
  "java",
  "yaml",
  "scala",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- set a formatter if you want to override the default lsp one (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    exe = "scalafmt",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    args = {'--stdin'},
    filetypes = {'scala','sc'},
  },
}

-- Additional Plugins
lvim.plugins = {
--   -- colors
    {'Mofiqul/vscode.nvim'},
    {'tjdevries/colorbuddy.vim'},
    {'Th3Whit3Wolf/onebuddy'},
    {'folke/tokyonight.nvim'},
--  -- Change colorscheme based on OS
    {
      "cormacrelf/dark-notify",
      requires = "Mofiqul/vscode.nvim",
      config = function()
        require("user.dark_notify").config()
      end
    },
--  -- Scala LSP
    {
      "scalameta/nvim-metals",
      config = function()
        require("user.metals").config()
      end,
    },
--  -- Manage git via Vim
    {
      "tpope/vim-fugitive",
      cmd = {
        "G",
        "Git",
        "Gdiffsplit",
        "Gread",
        "Gwrite",
        "Ggrep",
        "GMove",
        "GDelete",
        "GBrows e",
        "GRemove",
        "GRename",
        "Glgrep",
        "Gedit"
      },
      ft = {"fugitive"}
    },

--  -- Permalinks to git web hosts
    {
      "ruifm/gitlinker.nvim",
      event = "BufRead",
      requires = "nvim-lua/plenary.nvim",
      -- opts = {
      --   -- callback for what to do with the url
      --   action_callback = require"gitlinker.actions".copy_to_clipboard,
      -- },
      -- callbacks = {
      --   ["code.corp.creditkarma.com"] = require"gitlinker.hosts".get_github_type_url
      -- },
    },

--  -- Custom search
    {
      "windwp/nvim-spectre",
      event = "BufRead",
      config = function()
        require("spectre").setup()
      end,
    },

--   -- keybindings
   {'tpope/vim-unimpaired'},

--   -- tmux
   {'christoomey/vim-tmux-navigator'},

--   -- Custom Quickfix window
    {
      "kevinhwang91/nvim-bqf",
      event = { "BufRead", "BufNew" },
      config = function()
      require("bqf").setup({
              auto_enable = true,
              preview = {
              win_height = 12,
              win_vheight = 12,
              delay_syntax = 80,
              border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
              },
              func_map = {
              vsplit = "",
              ptogglemode = "z,",
              stoggleup = "",
              },
              filter = {
              fzf = {
              action_for = { ["ctrl-s"] = "split" },
              extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
              },
              },
              })
      end,
    },

--  -- Telescope symbols populator
  {'nvim-telescope/telescope-symbols.nvim'},


--  end additional plugins bloc
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }

-- Metals configuration
-- https://github.com/LunarVim/lunarvim.org/blob/1b2f36dcdb5cd1e4e1a9db34b538246bb0a47494/docs/languages/scala.md
lvim.autocommands.custom_groups = {
  { "FileType", "java,scala,sbt", "lua require('user.metals').config()" }
}

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- Write buffer (Save changes)
-- lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

---- search highlighted text
lvim.keys.visual_mode["//"] = 'y/<C-R>"<CR>'


lvim.builtin.which_key.mappings["x"] = {
  name = "+ripgrep search",
  f = { "<cmd>lua require('spectre').open()<cr>", "files" },
  s = { "<cmd>lua require('spectre').open_file_search()<cr>", "buffer" },
  w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "word" },
}
