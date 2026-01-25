--
-- Better view of diff
return {
  {
    enabled = false,
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    config = function()
      local actions = require("diffview.actions")
      
      require("diffview").setup({
        enhanced_diff_hl = true,
        view = {
          merge_tool = {
            -- Config for conflicted files in diff views during a merge or rebase.
            layout = "diff3_mixed",
            disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
            winbar_info = true, -- See |diffview-config-view.x.winbar_info|
          },
        },
        keymaps = {
          disable_defaults = false, -- Keep default keymaps
          view = {
            -- Conflict navigation (only works during active merge/rebase with conflict markers)
            { "n", "[x", actions.prev_conflict, { desc = "Jump to previous conflict" } },
            { "n", "]x", actions.next_conflict, { desc = "Jump to next conflict" } },
            
            -- Note: ]c and [c for diff hunk navigation are provided automatically by Vim's
            -- native diff mode. No need to map them here. They work out of the box!
            
            -- Help
            { "n", "g?", actions.help("view"), { desc = "Open the help panel" } },
          },
        },
      })
    end,
  },
}

-- ============================================================================
-- DIFFVIEW NAVIGATION GUIDE
-- ============================================================================
--
-- UNDERSTANDING DIFF vs CONFLICT NAVIGATION:
-- -----------------------------------------
-- ]c / [c  = Navigate diff HUNKS (changed sections) - provided by Vim's diff mode
-- ]x / [x  = Navigate CONFLICT markers (only during active merge/rebase)
--
-- For REGULAR DIFFS (comparing branches/commits like 908c65e^):
--   - Command: :DiffviewOpen [commit] or :DiffviewOpen branch1...branch2
--   - ]c / [c      = Jump to next/previous diff hunk (automatic via Vim diff mode)
--   - <tab> / <s-tab> = Navigate between changed files
--   - do           = Obtain diff (get change from other window)
--   - dp           = Put diff (send change to other window)
--   - Note: ]x / [x will NOT work - no conflict markers exist in regular diffs
--
-- For MERGE CONFLICTS (when you have <<<<<<< ======= >>>>>>> markers):
--   - Command: :DiffviewOpen during an active merge/rebase
--   - ]x / [x      = Navigate between conflict markers
--   - ]c / [c      = Jump to next/previous diff hunk
--   - <leader>co   = Choose "ours" version
--   - <leader>ct   = Choose "theirs" version
--   - <leader>cb   = Choose "base" version
--
-- TROUBLESHOOTING:
-- - If ]c doesn't work: Make sure you're in the diff buffer (not the file panel)
-- - If ]x doesn't work: You're viewing a regular diff, not a merge conflict
-- - Press g? in any diff view to see all available keybindings
--
-- ============================================================================
