return {
  "3rd/image.nvim",
  lazy = true,
  event = "VeryLazy",
  build = false, -- magick_cli; skip building the Lua rock
  opts = {
    backend = "kitty", -- Ghostty speaks the Kitty graphics protocol
    processor = "magick_cli", -- ImageMagick already installed
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = false, -- local-only
        only_render_image_at_cursor = false, -- always-on inline
        only_render_image_at_cursor_mode = "popup",
        floating_windows = false,
        filetypes = { "markdown", "vimwiki", "quarto" },
      },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50, -- clamp to 50% height
    scale_factor = 1.0,
    editor_only_render_when_focused = false,
    tmux_show_only_in_active_window = false,
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
  },
  config = function(_, opts)
    require("image").setup(opts)

    -- Command-only toggle (no keybinding): :EnableImageRender / :DisableImageRender
    vim.api.nvim_create_user_command("EnableImageRender", function()
      require("image").enable()
      vim.notify("image rendering enabled", vim.log.levels.INFO)
    end, { desc = "Enable image.nvim rendering" })

    vim.api.nvim_create_user_command("DisableImageRender", function()
      require("image").disable()
      vim.notify("image rendering disabled", vim.log.levels.INFO)
    end, { desc = "Disable image.nvim rendering" })
  end,
}
