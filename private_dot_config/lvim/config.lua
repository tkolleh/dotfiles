-- general
lvim.log.level = "warn"
lvim.format_on_save = false
vim.o.wrap = true
vim.o.linebreak = true
vim.o.showbreak = "⤦ "
vim.o.breakindent = true
vim.o.list = false
vim.o.timeoutlen = 700
vim.o.laststatus = 3
vim.opt.relativenumber = true

-- code folding
vim.o.foldenable = true
vim.o.foldlevel = 20
vim.o.foldlevelstart = 999
vim.o.foldcolumn = "2"
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

local ignore_file_buff_types = {"gitcommit", "gitrebase", "svn", "hgcommit", "quickfix", "nofile", "help", 'fugitive', 'nerdtree', 'tagbar', 'fzf', 'diff', 'NvimTree', 'aerial', 'Outline', 'DapSidebar', 'UltestSummary', 'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt'}

--  -- Optional core plugins
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "startify"

lvim.builtin.terminal.active = true
-- This was remapped to `<C-\>` in a recent update.
lvim.builtin.terminal.open_mapping = "<C-t>"

lvim.builtin.dap.active = true -- (default: false)

--  -- Nvim tree configuration
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.view.width = "25%"

lvim.format_on_save = false
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

-- Required for rmagatti/goto-preview plugin
lvim.keys.normal_mode["gp"] = false -- Disable lunarvim keybinding

-- Additional Plugins
lvim.plugins = {
    {
      'alker0/chezmoi.vim',
      lazy = false,
      init = function()
        -- This option is required.
        vim.g['chezmoi#use_tmp_buffer'] = true
        -- add other options here if needed.
      end,
    },
    {
      'norcalli/nvim-terminal.lua'
    },
    {
      'xvzc/chezmoi.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        require("chezmoi").setup {
          -- your configurations
        }
      end
    },
    {
      'fei6409/log-highlight.nvim',
      config = function()
          require('log-highlight').setup {}
      end,
    },
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      event = "BufRead",
    },
    {'tpope/vim-abolish'},
--   -- colors
    {'tjdevries/colorbuddy.vim'},
--  -- Change colorscheme based on OS
    {
      "cormacrelf/dark-notify",
      dependencies = {
        "Mofiqul/vscode.nvim",
        "folke/tokyonight.nvim",
        -- 'lunarvim/Onedarker.nvim',
      },
      config = function()
        require("user.dark_notify").config()
      end
    },
--  -- Permalinks to git web hosts
    {
      "ruifm/gitlinker.nvim",
      event = "BufRead",
      dependencies = "nvim-lua/plenary.nvim",
      config = function()
        require("user.gitlinker").config()
      end
    },
--  -- Git wrapper in vim
    {
      "tpope/vim-fugitive",
      cmd = { "G", "Git","Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit" },
      -- cmd = { "G", "Git", "Gdiffsplit!", "Gvdiffsplit", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit" },
      -- ft = {"fugitive"}
    },
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
--  -- Show context of current scope e.g. function, class, etc...
    {
      "romgrk/nvim-treesitter-context",
      config = function()
        require("treesitter-context").setup{
          enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
          throttle = true, -- Throttles plugin updates (may improve performance)
          max_lines = -1, -- How many lines the window should span. Values <= 0 mean no limit.
          patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
            -- For all filetypes
            -- Note that setting an entry here replaces all other patterns for this entry.
            -- By setting the 'default' entry below, you can control which nodes you want to
            -- appear in the context window.
            default = {
                'class',
                'function',
                'method',
                'for',
                'switch',
                'case',
                'interface',
                'struct',
                'enum',
            },
          },
        }
      end
    },
--  -- Document outline (structure)
    {
      'stevearc/aerial.nvim',
      config = function ()
        require("aerial").setup({
          -- Priority list of preferred backends for aerial.
          -- This can be a filetype map (see :help aerial-filetype-map)
          backends = { "treesitter", "lsp", "man" },
          -- This can be a filetype map (see :help aerial-filetype-map)
          -- To see all available values, see :help SymbolKind
          filter_kind = {
            "Class",
            "Constructor",
            "Enum",
            "Function",
            "Interface",
            "Module",
            "Method",
            "Struct",
          },
        })
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
--   -- sessiom manager
    {
      "folke/persistence.nvim",
        event = "BufReadPre", -- this will only start session saving when an actual file was opened
        config = function()
          require("persistence").setup {
            dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
            options = { "buffers", "curdir", "tabpages", "winsize" },
          }
        end,
    },
--   -- Auto save
    {
      'pocco81/auto-save.nvim',
      config = function ()
        require("auto-save").setup({
          enabled = false,
          trigger_events = {"InsertLeave"},
          on_off_commands = true,
          debounce_delay = 250,
          write_all_buffers = false,
        })
      end,
    },
--   -- Delete buffer without rearraging windows
    {'famiu/bufdelete.nvim'},
--   -- Highlight and search for TODO comments
    {
      "folke/todo-comments.nvim",
      event = "BufRead",
      config = function()
        require("todo-comments").setup()
      end,
    },
--   -- Function signature hint while typing. This one is the panda icon
    {
      "ray-x/lsp_signature.nvim",
      event = "BufRead",
      config = function()
        require("lsp_signature").setup({
          floating_window = true,
          floating_window_above_cur_line = true,
          doc_lines = 0,
          always_trigger = false,
          timer_interval = 100,
          floating_window_off_x = 5, -- adjust float windows x position.
          floating_window_off_y = function() -- adjust float windows y position. e.g. set to -2 can make floating window move up 2 lines
            local linenr = vim.api.nvim_win_get_cursor(0)[1] -- buf line number
            local pumheight = vim.o.pumheight
            local winline = vim.fn.winline() -- line number in the window
            local winheight = vim.fn.winheight(0)

            -- window top
            if winline - 1 < pumheight then
              return pumheight
            end

            -- window bottom
            if winheight - winline < pumheight then
              return -pumheight
            end
            return 0
          end,
      })
      end
    },
--  -- Prettier lsp builtin peek definition
--  -- TODO move configuration to separate config file
    {
      "rmagatti/goto-preview",
      config = function()
        require('goto-preview').setup {
            width = 120; -- Width of the floating window
            height = 25; -- Height of the floating window
            default_mappings = false; -- Bind default mappings
            debug = false; -- Print debug information
            opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
            resizing_mappings = false; -- Binds arrow keys to resizing the floating window.
            post_open_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.

            -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
            focus_on_open = true; -- Focus the floating window when opening it.
            dismiss_on_move = false; -- Dismiss the floating window when moving the cursor.
        }
        -- You can use "default_mappings = true" setup option
        -- Or explicitly set keybindings
        -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
        -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
        -- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")

        vim.api.nvim_set_keymap('n', 'gp',
          [[<Cmd>lua require('goto-preview').goto_preview_definition()<CR>]],
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap('n', 'gP',
          [[<Cmd>lua require('goto-preview').close_all_win()<CR>]],
          { noremap = true, silent = true }
        )
      end
    },
--  -- Focus on the last place of edit
    {
      'ethanholz/nvim-lastplace',
      config = function()
        require('nvim-lastplace').setup {
            lastplace_ignore_buftype = ignore_file_buff_types,
            lastplace_ignore_filetype = ignore_file_buff_types,
            lastplace_open_folds = true
        }
      end
    },
--  -- Smooth scrolling neovim plugin
    {
      'karb94/neoscroll.nvim',
      event = "WinScrolled",
      config = function ()
        require('neoscroll').setup()
      end
    },
--  -- View all the trouble in code
    {
      "folke/trouble.nvim",
        cmd = "TroubleToggle",
    },

--  -- Repeat plugin maps not just default
    {'tpope/vim-repeat'},

--  -- Change surroundings of word groups
    {
      "tpope/vim-surround",
      keys = {"c", "d", "y"}
      -- make sure to change the value of `timeoutlen` if it's not
      -- triggering correctly, see https://github.com/tpope/vim-surround/issues/117
      -- setup = function()
        --  vim.o.timeoutlen = 500
      -- end
    },
--   -- keybindings
   -- {'tpope/vim-unimpaired'},

--  -- Telescope extensions
    {'nvim-telescope/telescope-dap.nvim'},
    {'nvim-telescope/telescope-ui-select.nvim' },

--  -- Align text with motion
    {'junegunn/vim-easy-align'},

-- -- LSP file operations
    {
      'antosha417/nvim-lsp-file-operations',
      dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "kyazdani42/nvim-tree.lua" },
      }
    },

-- -- View diffs, use fugitive for merge conflicts
    {
      'sindrets/diffview.nvim',
      dependencies = 'nvim-lua/plenary.nvim'
    },

-- -- Copilot
  {
    "zbirenbaum/copilot.lua",
    event = { "VimEnter" },
    config = function()
      vim.defer_fn(
        function()
          require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
            plugin_manager_path = get_runtime_dir() .. "/site/pack/packer",
          })
        end,
      100.0)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua", "nvim-cmp" },
    config = function ()
      require("copilot_cmp").setup()
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    config = function()
      require 'nvim-treesitter.configs'.setup {
        textobjects = {
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              -- You can also use captures from other query groups like `locals.scm`
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V',  -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
            include_surrounding_whitespace = true,
          },
          move = {
            enable = true,
            set_jumps = false, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]]"] = "@function.outer",
              -- ["]["] = "@function.outer",
              ["]l"] = "@loop.outer",
              -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
            },
            goto_next_end = {
              ["]["] = "@function.outer",
              -- ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[["] = "@function.outer",
              -- ["[]"] = "@function.outer",
            },
            goto_previous_end = {
              ["[]"] = "@function.outer",
              -- ["[]"] = "@class.outer",
            },
            goto_next = {
              ["]c"] = "@conditional.outer",
            },
            goto_previous = {
              ["[c"] = "@conditional.outer",
            },
          },
          lsp_interop = {
            enable = true,
            border = 'none',
            -- peek_definition_code = {
            --   ["<leader>pf"] = "@function.outer",
            --   ["<leader>pF"] = "@class.outer",
            -- },
          },
        },
      }
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

--  end additional plugins bloc
}

-- -- nvim-cmp
-- Can not be placed into the config method of the plugins.
lvim.builtin.cmp.completion.keyword_length = 2
lvim.builtin.cmp.formatting.source_names["copilot"] = "(Copilot)"
table.insert(lvim.builtin.cmp.sources, 1, { name = "copilot" })

--  -- minimap configuration
vim.g.minimap_width = 10
vim.g.minimap_auto_start = 0
vim.g.minimap_auto_start_win_enter = 0
vim.g.minimap_git_colors = 1
vim.g.minimap_block_filetypes = ignore_file_buff_types
vim.g.minimap_block_buftypes = ignore_file_buff_types


-- Configure telescope
require("user.telescope").config()

-- Configure treesitter
require("user.treesitter").config()

-- Configure nvim-dap and dap-ui
require("user.dap").config()

-- Configure keymappings
require("user.keymappings").config()

-- Configure hocon filetype behavior
require("user.autocommands").hocon()

-- Configure drools filetype behavior
-- require("user.autocommands").drools()

-- Autocommands and helpers
require("user.autocommands").chezmoi()

-- status line (lualine)
lvim.builtin.lualine.style = "default" -- or "none"
lvim.builtin.lualine.options = {
  theme = 'tokyonight',
}

local components = require("lvim.core.lualine.components")
lvim.builtin.lualine.sections.lualine_x = {
 components.diagnostics,
 components.encoding,
 components.filetype,
}

local metals_status = require("user.metals").metals_status
local dap_status = require("user.dap").dap_status
lvim.builtin.lualine.sections.lualine_y = {
 components.progress,
 metals_status(),
 dap_status(),
}

lvim.builtin.illuminate.options.under_cursor = true

if vim.g.neovide then
  require("user.neovide").config()
end
