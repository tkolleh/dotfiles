return {
  "m00qek/baleia.nvim",
  cmd = { "PrettyLogs", "BaleiaColorize", "BaleiaLogs" }, -- lazy load on these commands
  version = "*",
  opts = {},
  config = function(_, opts)
    -- Store baleia instance in vim.g as shown in the documentation
    vim.g.baleia = require("baleia").setup(opts)

    -- Command to colorize the current buffer
    vim.api.nvim_create_user_command("BaleiaColorize", function()
      if vim.g.baleia then
        vim.g.baleia.once(vim.api.nvim_get_current_buf())
      end
    end, { bang = true })

    -- Alias for BaleiaColorize
    vim.api.nvim_create_user_command("PrettyLogs", function()
      if vim.g.baleia then
        vim.g.baleia.once(vim.api.nvim_get_current_buf())
      end
    end, { bang = true })

    -- Command to show logs (using vim.cmd.messages as per documentation)
    vim.api.nvim_create_user_command("BaleiaLogs", vim.cmd.messages, { bang = true })
  end,
}
