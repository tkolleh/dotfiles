-- Helper functions
--
-- re-assign lvim defaults
local function reassign_which_key(from, to)
  local mapping = lvim.builtin.which_key.mappings[from]
  lvim.builtin.which_key.mappings[to] = mapping
  lvim.builtin.which_key.mappings[from] = nil
end

-- Changes an existing mapping to a completely new one. Old mapping is deleted,
-- so should be re-assigned first.
local function change_which_key(key, mapping)
  lvim.builtin.which_key.mappings[key] = nil
  lvim.builtin.which_key.mappings[key] = mapping
end

-- default makes quitting the editor too easy
lvim.builtin.which_key.mappings["q"] = nil

-- general
lvim.log.level = "warn"
lvim.format_on_save = false
vim.o.wrap = true
vim.o.linebreak = true
-- vim.o.showbreak = "      ⤦ "
vim.o.showbreak = "⤦ "
vim.o.breakindent = true
vim.o.list = false
vim.o.timeoutlen = 700
vim.o.laststatus = 3

local ignore_file_buff_types = {"gitcommit", "gitrebase", "svn", "hgcommit", "quickfix", "nofile", "help", 'fugitive', 'nerdtree', 'tagbar', 'fzf', 'diff', 'NvimTree', 'aerial', 'Outline', 'DapSidebar', 'UltestSummary', 'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt'}

-- code folding
vim.o.foldenable = true
vim.o.foldlevel = 2
vim.o.foldlevelstart = 50
vim.o.foldcolumn = "2"
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

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
    {'tpope/vim-abolish'},
--   -- colors
    {'tjdevries/colorbuddy.vim'},
--  -- Change colorscheme based on OS
    {
      "cormacrelf/dark-notify",
      requires = {
        "Mofiqul/vscode.nvim",
        "folke/tokyonight.nvim",
        'lunarvim/Onedarker.nvim',
      },
      config = function()
        require("user.dark_notify").config()
      end
    },
--  -- Permalinks to git web hosts
    {
      "ruifm/gitlinker.nvim",
      event = "BufRead",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("user.gitlinker").config()
      end
    },
--  -- Git wrapper in vim
    {
      "tpope/vim-fugitive",
      cmd = { "G", "Git", "Gdiffsplit!", "Gvdiffsplit", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit" },
      -- ft = {"fugitive"}
    },
--  -- Custom search
    {
      --"windwp/nvim-spectre",
      "nvim-pack/nvim-spectre",
      event = "BufRead",
      config = function()
        require("user.spectre").config()
      end,
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
          backends = { "treesitter"},
          -- A list of all symbols to display. Set to false to display all symbols.
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
        module = "persistence",
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
--  -- Syntax highlighting for the HOCON language used by JVM config files
    {'jvirtanen/vim-hocon'},
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
   {'tpope/vim-unimpaired'},

--  -- Telescope extensions
    {'nvim-telescope/telescope-dap.nvim'},
    {'nvim-telescope/telescope-ui-select.nvim' },

--  -- Align text with motion
    {'junegunn/vim-easy-align'},

-- -- LSP file operations
    {
      'antosha417/nvim-lsp-file-operations',
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "kyazdani42/nvim-tree.lua" },
      }
    },

-- -- View diffs, use fugitive for merge conflicts
    {
      'sindrets/diffview.nvim',
      requires = 'nvim-lua/plenary.nvim'
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
-- -- Better matching ( % )
  {
    "andymass/vim-matchup",
    event = "CursorMoved",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
--  end additional plugins bloc
}

-- -- Aerial keybindings
local aerial = require("aerial")
lvim.builtin.which_key.mappings["o"] = { "<cmd>AerialToggle!<CR>", "Toggle Aerial" }
-- Jump forwards/backwards with '[' and ']'
lvim.builtin.which_key.mappings["["] = { aerial.prev, "Aerial previous symbol" }
lvim.builtin.which_key.mappings["]"] = { aerial.next, "Aerial next symbol" }
-- Jump up the tree with '{' or '}'
lvim.builtin.which_key.mappings["{"] = { aerial.prev_up, "Aerial previous" }
lvim.builtin.which_key.mappings["}"] = { aerial.next_up, "Aerial next" }

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

--  -- Speectre configuration
lvim.builtin.which_key.mappings["sx"] = { "<cmd>lua require('spectre').open()<cr>", "ripgrep search files" }
lvim.builtin.which_key.mappings["sX"] = { "<cmd>lua require('spectre').open_file_search()<cr>", "ripgrep search buffers" }
lvim.builtin.which_key.mappings["sw"] = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "ripgrep search selected word" }

--  -- Trouble keymappings / keybindings
lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  a = { "<cmd>TroubleToggle<cr>", "trouble" },
  T = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
  t = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
  q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
  l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

--  -- Persistence session manager keybindings / keymappings
lvim.builtin.which_key.mappings["S"]= {
  name = "Session",
  c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}

--  -- Telescope configuration
require("user.telescope").config()

-- -- Treesitter configuration
require("user.treesitter").config()

-- Configure nvim-dap and dap-ui
require("user.dap").config()

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

---- search highlighted text
lvim.keys.visual_mode["//"] = 'y/<C-R>"<CR>'

--- ESC from insert mode
lvim.keys.insert_mode["jk"] = '<ESC>'
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

lvim.builtin.illuminate.options.under_cursor = true

-- For inspiration:
-- https://github.com/ChristianChiarulli/lvim
-- https://github.com/abzcoding/lvim/blob/main/config.lua
-- https://github.com/mandreyel/dotfiles/tree/master/lvim/.config/lvim
