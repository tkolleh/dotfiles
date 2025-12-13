-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local utils = require("utils")
local unimpaired = require("utils.unimpaired")

local function _map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

_map({ "i" }, "jk", "<ESC>", { desc = "Escape to normal with 'jk'" })

-- d means delete not delete and copy
_map({ "n", "v" }, "d", '"_d')
_map({ "n", "v" }, "D", '"_D')

-- dont copy on paste
_map({ "v" }, "p", "P")

if LazyVim and LazyVim.pick then
  vim.keymap.set({ "v" }, "<leader>/", LazyVim.pick("grep_cword"), { noremap = true, desc = "Word (Root Dir)" })
end

-- Keymaps similar to Helix goto mode
-- See: https://docs.helix-editor.com/keymap.html#goto-mode
_map({ "n", "v" }, "gh", "^", { desc = "Go to first non-whitespace character of the line" })
_map({ "n", "v" }, "gl", "$", { desc = "Goto end of line" })

-- Keymaps set the paste register to the current buffer path
-- Includes the current line number thanks to `wsdjeg/vim-fetch`
_map({ "n" }, "<leader>fy", ":call setreg('+', expand('%:.') .. ':' .. line('.'))<CR>", { desc = "Yank path" })
_map({ "n" }, "<leader>fO", ":e <C-r>+<CR>", { noremap = true, desc = "Open path in clipboard" })

-- Enhanced diff with character-level indicators
_map({ "n" }, "<leader>gd", ":CodeDiff<CR>", { desc = "Code diff with character indicators" })

if LazyVim and LazyVim.pick then
  _map({ "v" }, "//", LazyVim.pick("grep_visual"), { desc = "Selection (Root Dir)" })
end

vim.keymap.set(
  { "n" },
  "<leader>cD",
  utils.cycle_diagnostics_display,
  { noremap = true, desc = "Cycle diagnostic display" }
)

--
-- Keymaps similar to vim unimpaired
-- See: https://github.com/tpope/vim-unimpaired/blob/master/doc/unimpaired.txt
--
-- Toggles only
if Snacks and Snacks.toggle then
  Snacks.toggle({
    name = "Toggle Background",
    get = utils.is_background_dark,
    set = function(state)
      if state then
        vim.cmd('set background=dark')
      else
        vim.cmd('set background=light')
      end
      utils.apply_auto_background_theme()
    end,
  }):map("yob")
end

if Snacks and Snacks.toggle then
  Snacks.toggle({
    name = "Toggle line wrap",
    get = unimpaired.is_wrapped,
    set = function(state)
      if state then
        unimpaired.enable_wrap()
      else
        unimpaired.disable_wrap()
      end
    end,
  }):map("yow")
end

if Snacks and Snacks.toggle then
  Snacks.toggle({
    name = "Toggle spell check",
    get = unimpaired.is_spellchecked,
    set = function(state)
      if state then
        unimpaired.enable_spell()
      else
        unimpaired.disable_spell()
      end
    end,
  }):map("yos")
end

if Snacks and Snacks.toggle then
  Snacks.toggle({
    name = "Toggle relative line number",
    get = unimpaired.is_relativenumber,
    set = function(state)
      if state then
        unimpaired.enable_relativenumber()
      else
        unimpaired.disable_relativenumber()
      end
    end,
  }):map("yor")
end

if Snacks and Snacks.toggle then
  Snacks.toggle({
    name = "Dark Colorscheme",
    get = utils.is_background_dark,
    set = function(state)
      if state then
        vim.cmd('set background=dark')
      else
        vim.cmd('set background=light')
      end
      utils.apply_auto_background_theme()
    end,
  }):map("<leader>ub")
end

-- Disable default keymaps
local del = vim.keymap.del

-- Unmap saving
del("i", "<C-s>")
del("v", "<C-s>")
-- del("n", "<leader>gy")
-- del("v", "<leader>gy")
-- del("n", "<leader>gY")
-- del("v", "<leader>gY")

--
-- Commands
--
vim.api.nvim_create_user_command('Marked', function()
  -- Get the absolute path of the current buffer
  local filepath = vim.fn.expand('%:p')
  
  -- Use jobstart to open it asynchronously without blocking the editor
  vim.fn.jobstart({'open', '-a', 'Marked 2', filepath}, { detach = true })
  end, {
  desc = 'Open current file in Marked 2'
})

