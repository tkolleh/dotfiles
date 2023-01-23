local function setup_defaults()
  lvim.builtin.telescope.defaults = {
    file_ignore_patterns = { "target", "node_modules", "parser.c", "out", "%.min.js" },
    prompt_prefix = "❯",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    path_display = { "smart" },
    dynamic_preview_title = true,
    theme = "dropdown",
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
  }
end

local function setup_pickers()
  -- Override default find_files picker to not show .git/ files but otherwise
  -- show all files, including hidden ones (e.g. .gitignore, .gitmodule, etc are all useful).
  lvim.builtin.telescope.defaults.pickers = {
    find_files = {
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "fd","--type=file","--hidden","--glob","!.git/*","--strip-cwd-prefix"},
      theme = "dropdown",
    },
    live_grep = {
      --@usage don't include the filename in the search results
      only_sort_text = true,
      theme = "dropdown",
    },
    buffers = {
      only_sort_text = true,
      theme = "dropdown"
    },
    oldfiles = {
      theme = "dropdown"
    },
  }
end

local function setup_mappings()
  local status_ok, actions = pcall(require, "telescope.actions")
  if not status_ok then
    vim.notify("telescope.actions not found", vim.log.levels.ERROR)
    return
  end
  lvim.builtin.telescope.defaults.mappings = {
    -- for insert mode
    i = {
      ["<C-j>"] = actions.move_selection_next,
      ["<C-k>"] = actions.move_selection_previous,
      ["<C-h>"] = actions.cycle_history_prev,
      ["<C-u>"] = false, -- clear input line rather than scroll preview
    },
    -- for normal mode
    n = {
      ["<C-j>"] = actions.move_selection_next,
      ["<C-k>"] = actions.move_selection_previous,
    },
  }
  --  -- Telescope LSP keymappings / keybindings
  lvim.keys.normal_mode["<leader>ss"] = false
  lvim.builtin.which_key.mappings["ss"] = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" }

  lvim.keys.normal_mode["<leader>sS"] = false
  lvim.builtin.which_key.mappings["sS"] = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols"}

  lvim.keys.normal_mode["<leader>sb"] = false
  lvim.builtin.which_key.mappings["sb"] = { "<cmd>Telescope buffers<cr>", "Find Buffer" }

  lvim.keys.normal_mode["<leader>sB"] = false
  lvim.builtin.which_key.mappings["sB"] = { "<cmd>Telescope git_branches<cr>", "Checkout branch" }

  -- keymappings / keybindings [view all the defaults by pressing <leader>Lk]
  lvim.builtin.which_key.mappings["j"] = { "<cmd>Telescope jumplist<cr>", "Jump List" }

  vim.api.nvim_set_keymap(
    'n',
    '<S-Tab>',
    [[<Cmd>Telescope buffers<CR>]],
    { noremap = true, silent = true }
  )
end

local M = {}
M.config = function()
  setup_defaults()
  setup_pickers()
  setup_mappings()
  --  -- See configuration details: https://github.com/LunarVim/LunarVim/issues/2426
  lvim.builtin.telescope.on_config_done = function(tele)
    pcall(tele.load_extension, "dap")
    pcall(tele.load_extension, "ui-select")
    vim.cmd "autocmd User TelescopePreviewerLoaded setlocal wrap"
    -- local opts = {}
    -- tele.setup(opts)
  end
end

return M
