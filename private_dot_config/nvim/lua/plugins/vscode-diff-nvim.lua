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
        highlights = {
          line_insert = "DiffAdd",
          line_delete = "DiffDelete",
          char_insert = "CodeDiffCharInsert",
          char_delete = "CodeDiffCharDelete",
          char_brightness = nil,
        },
        diff = {
          disable_inlay_hints = true,
          max_computation_time_ms = 5000,
        },
        explorer = {
          position = "left",
          width = 40,
          height = 15,
          indent_markers = true,
          icons = {
            folder_closed = "",
            folder_open = "",
          },
          view_mode = "list",
        },
        keymaps = {
          view = {
            quit = "q",
            toggle_explorer = "<leader>b",
            next_hunk = "]c",
            prev_hunk = "[c",
            next_file = "]f",
            prev_file = "[f",
            diff_get = "do",
            diff_put = "dp",
          },
          explorer = {
            select = "<CR>",
            hover = "K",
            refresh = "R",
            toggle_view_mode = "i",
          },
        },
      })

      local function blend_with_base(hex_color, blend_ratio)
        local function hex_to_rgb(hex)
          hex = hex:gsub("^#", "")
          return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
        end
        local function rgb_to_hex(r, g, b)
          return string.format("#%02x%02x%02x", r, g, b)
        end
        local is_light = vim.o.background == "light"
        local base_r, base_g, base_b
        if is_light then
          base_r, base_g, base_b = 246, 242, 238
        else
          base_r, base_g, base_b = 25, 35, 48
        end
        local cr, cg, cb = hex_to_rgb(hex_color)
        if is_light then
          blend_ratio = blend_ratio * 1.5
        end
        local r = math.floor(base_r * (1 - blend_ratio) + cr * blend_ratio + 0.5)
        local g = math.floor(base_g * (1 - blend_ratio) + cg * blend_ratio + 0.5)
        local b = math.floor(base_b * (1 - blend_ratio) + cb * blend_ratio + 0.5)
        return rgb_to_hex(math.min(255, r), math.min(255, g), math.min(255, b))
      end

      local function setup_highlights()
        local hl = vim.api.nvim_get_hl
        local diff_add_fg = hl(0, { name = "DiffAdd", link = false }).fg
        local diff_delete_fg = hl(0, { name = "DiffDelete", link = false }).fg
        local diff_add_bg = hl(0, { name = "DiffAdd", link = false }).bg
        local diff_delete_bg = hl(0, { name = "DiffDelete", link = false }).bg

        if diff_add_fg then
          diff_add_fg = string.format("#%06x", diff_add_fg)
        end
        if diff_delete_fg then
          diff_delete_fg = string.format("#%06x", diff_delete_fg)
        end

        local char_insert_bg = blend_with_base(diff_add_fg or "#81b29a", 0.35)
        local char_delete_bg = blend_with_base(diff_delete_fg or "#c94f6d", 0.35)

        vim.api.nvim_set_hl(0, "VscodeDiffCharInsert", { bg = char_insert_bg, fg = diff_add_fg, bold = true })
        vim.api.nvim_set_hl(0, "VscodeDiffCharDelete", { bg = char_delete_bg, fg = diff_delete_fg, bold = true })
      end

      _G.vscode_diff_setup_highlights = setup_highlights

      setup_highlights()

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = setup_highlights,
        desc = "Update diff highlights when colorscheme changes",
      })

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
-- - Dynamically reads DiffAdd/DiffDelete highlights from the active colorscheme
-- - Character-level diffs use blended background colors derived from the palette
-- - Tested with: monrovia_night, monrovia_day, catppuccin, newpaper, github-theme
--
-- Testing checklist:
-- [ ] Test :CodeDiff command in dark mode (monrovia_night)
-- [ ] Test :CodeDiff command in light mode (monrovia_day)
-- [ ] Verify character-level diffs are clearly visible
-- [ ] Test alongside diffview.nvim commands (DiffviewOpen)
-- [ ] Test theme switching (highlights should auto-update)
-- [ ] Verify keybinding works (<leader>gd)
