-- Enhanced diff functionality with character-level indicators
-- This plugin complements diffview.nvim by providing character-level diff visualization
-- Works in both dark and light color schemes

return {
  {
    "esmuellert/codediff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "CodeDiff",
    config = function()
      require("codediff").setup({
        -- Highlight configuration
        highlights = {
          -- Line-level: Use existing DiffAdd/DiffDelete groups
          line_insert = "DiffAdd", -- Line-level insertions
          line_delete = "DiffDelete", -- Line-level deletions

          -- Character-level: Define custom highlights for better visibility
          -- These will be set up below with theme-aware colors
          char_insert = "CodeDiffCharInsert",
          char_delete = "CodeDiffCharDelete",

          -- Brightness multiplier is not needed since we're defining custom highlights
          char_brightness = nil,
        },

        -- Diff view behavior
        diff = {
          disable_inlay_hints = true, -- Disable inlay hints for cleaner view
          max_computation_time_ms = 5000, -- Maximum time for diff computation
        },

        -- Explorer panel configuration
        explorer = {
          position = "left", -- "left" or "bottom"
          width = 40, -- Width when position is "left" (columns)
          height = 15, -- Height when position is "bottom" (lines)
          indent_markers = true, -- Show indent markers in tree view
          icons = {
            folder_closed = "", -- Nerd Font folder icon
            folder_open = "", -- Nerd Font folder-open icon
          },
          view_mode = "list", -- "list" or "tree"
        },

        -- Keymaps in diff view
        keymaps = {
          view = {
            quit = "q", -- Close diff tab
            toggle_explorer = "<leader>b", -- Toggle explorer visibility
            next_hunk = "]c", -- Jump to next change
            prev_hunk = "[c", -- Jump to previous change
            next_file = "]f", -- Next file in explorer mode
            prev_file = "[f", -- Previous file in explorer mode
            diff_get = "do", -- Get change from other buffer
            diff_put = "dp", -- Put change to other buffer
          },
          explorer = {
            select = "<CR>", -- Open diff for selected file
            hover = "K", -- Show file diff preview
            refresh = "R", -- Refresh git status
            toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
          },
        },
      })

      -- Configure highlight groups for dark themes
      local function setup_dark_highlights()
        -- Line-level highlights (using existing groups)
        vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#1a3a1a", fg = "#a6e3a1" })
        vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#3a1a1a", fg = "#f38ba8" })
        vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1a2a3a", fg = "#89b4fa" })
        vim.api.nvim_set_hl(0, "DiffText", { bg = "#3a3a1a", fg = "#f9e2af", bold = true, underline = true })

        -- Character-level diff highlights (custom for vscode-diff)
        vim.api.nvim_set_hl(0, "VscodeDiffCharInsert", { bg = "#2a5a2a", fg = "#b8f4b1", bold = true })
        vim.api.nvim_set_hl(0, "VscodeDiffCharDelete", { bg = "#5a2a2a", fg = "#f5a8c8", bold = true })
      end

      -- Configure highlight groups for light themes
      local function setup_light_highlights()
        -- Line-level highlights - much lighter backgrounds for better visibility
        vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#e6f7e6", fg = "#2a6a2a" })
        vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#ffe6e6", fg = "#8a2a2a" })
        vim.api.nvim_set_hl(0, "DiffChange", { bg = "#e6f0ff", fg = "#2a4a8a" })
        vim.api.nvim_set_hl(0, "DiffText", { bg = "#fff4e6", fg = "#8a6a2a", bold = true, underline = true })

        -- Character-level diff highlights - slightly darker than line highlights
        vim.api.nvim_set_hl(0, "VscodeDiffCharInsert", { bg = "#c6e7c6", fg = "#1a5a1a", bold = true })
        vim.api.nvim_set_hl(0, "VscodeDiffCharDelete", { bg = "#ffc6c6", fg = "#7a1a1a", bold = true })
      end

      -- Set up highlights based on current background
      local function setup_highlights()
        if vim.o.background == "dark" then
          setup_dark_highlights()
        else
          setup_light_highlights()
        end
      end

      -- Expose setup_highlights globally for manual calling
      _G.vscode_diff_setup_highlights = setup_highlights

      -- Set initial highlights
      setup_highlights()

      -- Create autocommand to update highlights when colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = setup_highlights,
        desc = "Update diff highlights when colorscheme changes",
      })

      -- Also update when background changes
      vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "background",
        callback = setup_highlights,
        desc = "Update diff highlights when background option changes",
      })
    end,
  },
}

-- Integration with diffview.nvim:
-- - Both plugins can be used together without conflicts
-- - diffview.nvim provides repository-wide diff views and merge tools
-- - vscode-diff.nvim provides character-level diff visualization for specific comparisons
--
-- Usage:
-- - :CodeDiff [file1] [file2] - Compare two files with character-level diffs
-- - :CodeDiff - Open diff selector interface
-- - :CodeDiff HEAD [file] - Compare file with HEAD version
-- - :CodeDiff [commit] [file] - Compare file with specific commit
-- - Use <leader>gd keybinding (configured in keymaps.lua) for quick access
--
-- Color scheme compatibility:
-- - Automatically adjusts highlights for dark/light modes
-- - Tested with: nightfox, catppuccin, newpaper, github-theme
-- - Character-level diffs use bold text and distinct background colors
--
-- Testing checklist:
-- [ ] Test :CodeDiff command in dark mode (nightfox)
-- [ ] Test :CodeDiff command in light mode (catppuccin-latte, newpaper)
-- [ ] Verify character-level diffs are clearly visible
-- [ ] Test alongside diffview.nvim commands (DiffviewOpen)
-- [ ] Test theme switching (highlights should auto-update)
-- [ ] Verify keybinding works (<leader>gd)
