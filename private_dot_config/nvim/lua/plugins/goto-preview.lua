--
-- Display LSP results in preview window
return {
	{
		"rmagatti/goto-preview",
    dependencies = { "rmagatti/logger.nvim" },
		event = "VeryLazy",
		config = true,
		opts = {
			border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
			default_mappings = true,
			resizing_mappings = true,
      references = { -- Configure the telescope UI for slowing the references cycling window.
        provider = "fzf_lua", -- telescope|fzf_lua|snacks|mini_pick|default
        telescope = nil
        -- telescope = require("telescope.themes").get_dropdown({ hide_preview = false })
      },
			post_open_hook = function(_, winid)
				vim.keymap.set("n", "q", function()
					vim.api.nvim_win_close(winid, false)
				end)
			end,
		},
	},
}
