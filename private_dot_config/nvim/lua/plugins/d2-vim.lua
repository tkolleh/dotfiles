return {
  "terrastruct/d2-vim",
  ft = { "d2" },
  keys = {
    -- disable default keymaps and prefer the commands
    {"<Leader>d2", false}, -- Render selected text as ASCII (visual mode, any file)
    {"<Leader>d2", false}, -- Render entire buffer as ASCII (normal mode, D2 files only)
    {"<Leader>rd", false}, -- Replace selected D2 code with ASCII render (visual mode, any file)
    {"<Leader>yd", false}, -- Copy ASCII preview content to clipboard and yank register (normal mode, any file)
  }
}
