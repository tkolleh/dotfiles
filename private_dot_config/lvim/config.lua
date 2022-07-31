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
lvim.format_on_save = false
vim.o.wrap = true
vim.o.linebreak = true
vim.o.showbreak="        "
-- vim.o.showbreak = "⤦"
vim.o.list = false
vim.o.timeoutlen = 700
vim.o.laststatus = 3

local ignore_file_buff_types = {"gitcommit", "gitrebase", "svn", "hgcommit", "quickfix", "nofile", "help", 'fugitive', 'nerdtree', 'tagbar', 'fzf', 'diff', 'nvimtree', 'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt'}

-- code folding
vim.o.foldenable = true
vim.o.foldlevel = 2
vim.o.foldlevelstart = 50
vim.o.foldcolumn = "2"
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"


--  -- Optional core plugins
lvim.builtin.alpha.mode = "startify"
lvim.builtin.terminal.active = true
lvim.builtin.cmp.completion.keyword_length = 2
lvim.builtin.dap.active = true -- (default: false)

--  -- Nvim tree configuration
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.view.width = "25%"
lvim.builtin.nvimtree.setup.renderer.highlight_opened_files = "all"

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

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "metals" })

-- Additional Plugins
lvim.plugins = {
--   -- colors
    {'tjdevries/colorbuddy.vim'},
    {'Mofiqul/vscode.nvim'},
    {'folke/tokyonight.nvim'},
--  -- Change colorscheme based on OS
    {
      "cormacrelf/dark-notify",
      requires = {"Mofiqul/vscode.nvim", "folke/tokyonight.nvim"},
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
      cmd = {
        "G",
        "Git",
        "Gdiffsplit",
        "Gread",
        "Gwrite",
        "Ggrep",
        "GMove",
        "GDelete",
        "GBrowse",
        "GRemove",
        "GRename",
        "Glgrep",
        "Gedit"
      },
      ft = {"fugitive"}
    },
--  -- Custom search
    {
      "windwp/nvim-spectre",
      event = "BufRead",
      config = function()
        require("user.spectre").config()
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
--  -- Show context of current scope e.g. function, class, etc...
    {
      "romgrk/nvim-treesitter-context",
      config = function()
        require("treesitter-context").setup{
          enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
          throttle = true, -- Throttles plugin updates (may improve performance)
          max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
          patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
            -- For all filetypes
            -- Note that setting an entry here replaces all other patterns for this entry.
            -- By setting the 'default' entry below, you can control which nodes you want to
            -- appear in the context window.
            default = {
              'class',
              'function',
              'method',
            },
          },
        }
      end
    },
--  -- Document outline (structure)
    {
      'stevearc/aerial.nvim',
      event = { "BufRead", "BufNew" },
      config = function ()
        require("aerial").setup({
          on_attach = function(bufnr)
            -- Toggle the aerial window with <leader>a
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>AerialToggle!<CR>', {})
            -- Jump forwards/backwards with '{' and '}'
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '{', '<cmd>AerialPrev<CR>', {})
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '}', '<cmd>AerialNext<CR>', {})
            -- Jump up the tree with '[[' or ']]'
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '[[', '<cmd>AerialPrevUp<CR>', {})
            vim.api.nvim_buf_set_keymap(bufnr, 'n', ']]', '<cmd>AerialNextUp<CR>', {})
          end
        })
      end
    },
--  -- Debugger UI
    {
      "rcarriga/nvim-dap-ui",
      config = function ()
        require('dapui').setup()
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
    {'Shatur/neovim-session-manager'},
--   -- Auto save
    {
      'Pocco81/AutoSave.nvim',
      config = function ()
        require("autosave").setup({
          enabled = false,
          on_off_commands = true,
          conditions = {
              exists = true,
          },
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
--   -- Function signature hint while typing
    {
      "ray-x/lsp_signature.nvim",
      event = "BufRead",
      config = function()
        require("lsp_signature").setup({
          always_trigger = false,
          timer_interval = 300,
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
--  -- Telescope extensions
    {'nvim-telescope/telescope-dap.nvim'},
    {'nvim-telescope/telescope-ui-select.nvim' },

--  end additional plugins bloc
}

--  -- Telescope configuration
lvim.builtin.telescope.defaults.layout_config.width = 0.95

--  -- minimap configuration
vim.g.minimap_width = 10
vim.g.minimap_auto_start = 0
vim.g.minimap_auto_start_win_enter = 0
vim.g.minimap_git_colors = 1
vim.g.minimap_block_filetypes = ignore_file_buff_types
vim.g.minimap_block_buftypes = ignore_file_buff_types

--  -- Speectre configuration
lvim.builtin.which_key.mappings["ss"] = {
  name = "+ripgrep search",
  f = { "<cmd>lua require('spectre').open()<cr>", "files" },
  b = { "<cmd>lua require('spectre').open_file_search()<cr>", "buffers" },
  w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "selected word" },
}

--  -- WIP for better configuration: https://github.com/LunarVim/LunarVim/issues/2426
lvim.builtin.telescope.on_config_done = function(tele)
  pcall(tele.load_extension, "dap")
  pcall(tele.load_extension, "ui-select")
  local opts = {
    pickers = {
      find_files = {
        find_command = { "fd", "--type=file", "--hidden", "--strip-cwd-prefix" },
        theme = "dropdown",
      },
      live_grep = {
        --@usage don't include the filename in the search results
        only_sort_text = true,
        theme = "dropdown",
      },
      buffers = {
        theme = "dropdown"
      },
      oldfiles = {
        theme = "dropdown"
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


-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
lvim.builtin.which_key.mappings["j"] = { "<cmd>Telescope jumplist<cr>", "Jump List" }

-- TODO: Delete this line and the following.
-- The following commands are not needed as this is done by default
-- lvim.keys.normal_mode["gd"] = { "<cmd>Telescope lsp_definitions<cr>", "Goto definition"}
-- lvim.keys.normal_mode["gr"] = { "<cmd>Telescope lsp_references<cr>", "Goto references"}
-- lvim.keys.normal_mode["gI"] = { "<cmd>Telescope lsp_implementations<cr>", "Goto implementations"}
-- lvim.keys.normal_mode["<S-Tab>"] = { "<cmd>Telescope buffers<cr>", "Find buffer"}
vim.api.nvim_set_keymap('n', '<S-Tab>',
  [[<Cmd>Telescope buffers<CR>]],
  { noremap = true, silent = true }
)
---- search highlighted text
lvim.keys.visual_mode["//"] = 'y/<C-R>"<CR>'


