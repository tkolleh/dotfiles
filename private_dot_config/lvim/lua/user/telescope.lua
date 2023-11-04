local h = require("user.helpers")

local function getActions()
  local status_ok, actions = pcall(require, "telescope.actions")
  if not status_ok then
    vim.notify("telescope.actions not found", vim.log.levels.ERROR)
    return {}
  end
  return actions
end

local actions = getActions()

local function setup_defaults()
  lvim.builtin.telescope.defaults.file_ignore_patterns = { "target", "node_modules", "parser.c", "out", "%.min.js" }
  lvim.builtin.telescope.defaults.prompt_prefix = "❯"
  lvim.builtin.telescope.defaults.selection_caret = " "
  lvim.builtin.telescope.defaults.sorting_strategy = "ascending"
  lvim.builtin.telescope.defaults.layout_strategy = "horizontal"
  lvim.builtin.telescope.defaults.path_display = { "absolute" }
  lvim.builtin.telescope.defaults.wrap_results = true
  lvim.builtin.telescope.defaults.dynamic_preview_title = true
  lvim.builtin.telescope.defaults.theme = "dropdown"
  lvim.builtin.telescope.defaults.mappings.i["<esc>"] = actions.close
  lvim.builtin.telescope.defaults.winblend = 10

  lvim.builtin.telescope.defaults.layout_config = {
    -- prompt_position = "top",
    height = 0.9,
    width = 0.9,
    bottom_pane = {
      height = 25,
      preview_cutoff = 120,
    },
    center = {
      height = 0.9,
      preview_cutoff = 40,
      width = 0.9,
    },
    cursor = {
      preview_cutoff = 40,
    },
    horizontal = {
      width = 0.9,
      preview_cutoff = 120,
      preview_width = 0.9,
    },
    vertical = {
      preview_cutoff = 70,
    },
    flex = {
      flip_columns = 150,
    },
  }
end

local function setup_pickers()
  for key, _ in pairs(lvim.builtin.telescope.pickers) do
    if key ~= "planets" then
      lvim.builtin.telescope.pickers[key].previewer = nil
      lvim.builtin.telescope.pickers[key].theme = "dropdown"
      lvim.builtin.telescope.pickers[key].layout_strategy = nil
    end
  end

  lvim.builtin.telescope.pickers.git_files.previewer = nil
  -- show all files, including hidden ones (e.g. .gitignore, .gitmodule, etc are all useful).
  -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
  lvim.builtin.telescope.pickers.find_files.find_command = { "fd","--type=file","--hidden","--glob","!.git/*","--strip-cwd-prefix"}
  lvim.builtin.telescope.pickers.live_grep.only_sort_text = true
  lvim.builtin.telescope.pickers.buffers.only_sort_text = true
end

local M = {}
M.config = function()
  setup_defaults()
  setup_pickers()
  --  -- See configuration details: https://github.com/LunarVim/LunarVim/issues/2426
  lvim.builtin.telescope.on_config_done = function(tele)
    -- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
    local _, actions = pcall(require, "telescope.actions")
    tele.load_extension("dap")
    tele.load_extension("ui-select")

    local opts = {
      defaults = {
        theme = "dropdown",
        layout_config = {
          prompt_position = "top",
          width = 98,
          height = 90,
        }
      },
      buffers = {
        sort_mru = true,
        ignore_current_buffer = true,
        mappings = {
          i = {
            ["<c-x>"] = actions.delete_buffer,
          },
          n = {
            ["x"] = actions.delete_buffer,
          },
        },
      },
    }
    tele.setup(opts)
  end
end

return M
