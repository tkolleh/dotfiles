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
local function metals_status()
  return vim.g["metals_status"] or ""
end

local components = require("lvim.core.lualine.components")
lvim.builtin.lualine.sections.lualine_x = {
  components.encoding,
  components.filetype,
}
lvim.builtin.lualine.sections.lualine_y = {
  components.progress,
  metals_status,
}

--  -- Optional core plugins
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true

require("user.dap").config(true)

--  -- Telescope configuration
--  -- WIP for better configuration: https://github.com/LunarVim/LunarVim/issues/2426
lvim.builtin.telescope.on_config_done = function(tele)
  local opts = {
    pickers = {
      find_files = {
        find_command = { "fd", "--type=file", "--hidden", "--smart-case", "--strip-cwd-prefix" },
      },
      live_grep = {
        --@usage don't include the filename in the search results
        only_sort_text = true,
      },
    },
    defaults = {
      file_ignore_patterns = { "target", "node_modules", "parser.c", "out", "%.min.js" },
      prompt_prefix = "❯",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
          horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
          },
          vertical = {
              mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
      },
    },
  }
  tele.setup(opts)
end

--  -- Nvim tree configuration
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
--  -- Thrift syntax plugin
    { "solarnz/thrift.vim" },
--  -- Permalinks to git web hosts
    {
      "ruifm/gitlinker.nvim",
      event = "BufRead",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("user.gitlinker").config()
      end
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
  -- {'nvim-telescope/telescope-symbols.nvim'},

--  -- Debugger UI
    {
      "rcarriga/nvim-dap-ui",
      config = function()
        require('dapui').setup()
        lvim.builtin.which_key.mappings["dv"] = { "<cmd>lua require 'dapui'.toggle()<cr>", "Toggle Sidebar" }
      end,
    },

--  end additional plugins bloc
}

--Metals configuration
lvim.autocommands.custom_groups = {
  { "FileType", "scala,sbt,sc", "lua require('user.metals').config()" }
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
