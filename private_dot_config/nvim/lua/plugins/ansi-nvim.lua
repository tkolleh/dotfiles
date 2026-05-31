return {
  '0xferrous/ansi.nvim',
  config = function()
    require('ansi').setup({
      auto_enable = true,        -- Auto-enable for configured filetypes
      auto_enable_stdin = true,   -- Auto-enable for piped stdin content
      filetypes = { 'log', 'ansi' },
    })
  end
}
