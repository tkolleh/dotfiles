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

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

---- search highlighted text
lvim.keys.visual_mode["//"] = 'y/<C-R>"<CR>'

-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"


-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- lvim.builtin.telescope.on_config_done = function()
--   local actions = require "telescope.actions"
--   -- for input mode
--   lvim.builtin.telescope.defaults.mappings.i["<C-j>"] = actions.move_selection_next
--   lvim.builtin.telescope.defaults.mappings.i["<C-k>"] = actions.move_selection_previous
--   lvim.builtin.telescope.defaults.mappings.i["<C-n>"] = actions.cycle_history_next
--   lvim.builtin.telescope.defaults.mappings.i["<C-p>"] = actions.cycle_history_prev
--   -- for normal mode
--   lvim.builtin.telescope.defaults.mappings.n["<C-j>"] = actions.move_selection_next
--   lvim.builtin.telescope.defaults.mappings.n["<C-k>"] = actions.move_selection_previous
-- end

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
-- }

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

-- generic LSP settings
-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
-- lvim.lsp.null_ls.setup = {
--   root_dir = require("lspconfig").util.root_pattern("Makefile", ".git", "node_modules"),
-- }
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("Makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

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

-- notes
   {'renerocksai/telekasten.nvim'},
--  {
--    "folke/trouble.nvim",
--    cmd = "TroubleToggle",
--  },

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

lvim.builtin.which_key.mappings["x"] = {
  name = "+ripgrep search",
  f = { "<cmd>lua require('spectre').open()<cr>", "files" },
  s = { "<cmd>lua require('spectre').open_file_search()<cr>", "buffer" },
  w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "word" },
}
