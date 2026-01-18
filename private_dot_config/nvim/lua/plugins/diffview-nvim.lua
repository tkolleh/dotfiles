--
-- Better view of diff
return {
  {
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
            -- Add explicit conflict navigation (these are defaults but making them explicit)
            { "n", "[x", actions.prev_conflict, { desc = "Jump to previous conflict" } },
            { "n", "]x", actions.next_conflict, { desc = "Jump to next conflict" } },
            
            -- Add diff hunk navigation using same keys as vscode-diff
            { "n", "[c", actions.prev_entry, { desc = "Previous diff hunk/entry" } },
            { "n", "]c", actions.next_entry, { desc = "Next diff hunk/entry" } },
            
            -- Help
            { "n", "g?", actions.help("view"), { desc = "Open the help panel" } },
          },
        },
      })
    end,
  },
}

-- Navigation Guide:
-- 
-- For MERGE CONFLICTS (when you have <<<<<<< ======= >>>>>>> markers):
--   - Use :DiffviewOpen --merge or just :DiffviewOpen during a merge/rebase
--   - [x and ]x - Navigate between conflict markers
--   - <leader>co - Choose "ours" version
--   - <leader>ct - Choose "theirs" version
--   - <leader>cb - Choose "base" version
--
-- For REGULAR DIFFS (comparing branches/commits):
--   - Use :DiffviewOpen or :DiffviewOpen branch1...branch2
--   - ]c and [c - Navigate between changed sections (hunks)
--   - <tab> and <s-tab> - Navigate between files
--   - In the diff buffer itself, you can also use native Vim diff commands:
--     - ]c and [c - Jump to next/previous change
--     - do - Obtain diff (get change from other window)
--     - dp - Put diff (send change to other window)
--
-- Press g? in any diff view to see all available keybindings
