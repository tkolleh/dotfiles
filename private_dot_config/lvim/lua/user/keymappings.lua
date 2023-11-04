-- keymappings / keybindings [view all the defaults by pressing <leader>Lk]
--

local h = require("user.helpers")

local M = {}
M.config = function()
  ---- search highlighted text
  lvim.keys.visual_mode["//"] = 'y/<C-R>"<CR>'

  --- ESC from insert mode
  lvim.keys.insert_mode["jk"] = '<ESC>'
  lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
  lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
  lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

  -- default makes quitting the editor too easy
  h.which_key_remove_key("q")

  -- Cycle through buffers using telescope with <leader>b or <S-tab>
  h.which_key_remove_key("b")
  h.which_key_map_key("b", { ":Telescope buffers previewer=true<cr>", "Find" })
  lvim.keys.normal_mode["<S-Tab>"] = ":Telescope buffers previewer=true<CR>"

  -- Perform other buffer actions using 
  lvim.builtin.which_key.mappings["B"] = {
    name = "Buffers*",
    j = { ":BufferLinePick<cr>", "Jump" },
    b = { ":BufferLineCyclePrev<cr>", "Previous" },
    n = { ":BufferLineCycleNext<cr>", "Next" },
    W = { ":noautocmd w<cr>", "Save without formatting (noautocmd)" },
    e = {
      ":BufferLinePickClose<cr>",
      "Pick which buffer to close",
    },
    h = { ":BufferLineCloseLeft<cr>", "Close all to the left" },
    l = {
      ":BufferLineCloseRight<cr>",
      "Close all to the right",
    },
    D = {
      ":BufferLineSortByDirectory<cr>",
      "Sort by directory",
    },
    L = {
      ":BufferLineSortByExtension<cr>",
      "Sort by language",
    },
  }

  h.which_key_map_key("j", { ":Telescope jumplist<cr>", "Jump List" })

  -- -- Aerial keybindings
  h.which_key_map_key("o", { ":AerialToggle!<CR>", "Toggle Aerial" })
  -- Jump forwards/backwards with '[' and ']'
  h.which_key_map_key("[", { ":AerialPrev<CR>", "Aerial previous symbol" })
  h.which_key_map_key("]", { ":AerialNext<CR>", "Aerial next symbol" })

  -- Speectre configuration
  h.which_key_remove_key("/") -- dont use for comment toggle
  h.which_key_map_key("/", { ":lua require('spectre').open()<cr>", "Search project files" })

  -- Trouble keymappings / keybindings
  lvim.builtin.which_key.mappings["t"] = {
    name = "Diagnostics",
    a = { ":TroubleToggle<cr>", "trouble" },
    T = { ":TroubleToggle workspace_diagnostics<cr>", "workspace" },
    t = { ":TroubleToggle document_diagnostics<cr>", "document" },
    q = { ":TroubleToggle quickfix<cr>", "quickfix" },
    l = { ":TroubleToggle loclist<cr>", "loclist" },
    r = { ":TroubleToggle lsp_references<cr>", "references" },
  }

  -- Persistence session manager keybindings / keymappings
  lvim.builtin.which_key.mappings["S"]= {
    name = "Session",
    c = { ":lua require('persistence').load()<cr>", "Restore last session for current dir" },
    l = { ":lua require('persistence').load({ last = true })<cr>", "Restore last session" },
    Q = { ":lua require('persistence').stop()<cr>", "Quit without saving session" },
  }

end

return M
