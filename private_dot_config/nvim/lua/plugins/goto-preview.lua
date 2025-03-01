--
-- Display LSP results in preview window
return {
	{
		"rmagatti/goto-preview",
		event = "VeryLazy",
		config = true,
		opts = {
			border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
			default_mappings = true,
			resizing_mappings = true,
			post_open_hook = function(_, winid)
				vim.keymap.set("n", "q", function()
					vim.api.nvim_win_close(winid, false)
				end)
			end,
		},
	},
}
