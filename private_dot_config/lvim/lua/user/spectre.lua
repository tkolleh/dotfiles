local M = {}

M.config = function ()
  require('spectre').setup({
    open_cmd = 'new',
  })

  lvim.builtin.which_key.mappings["ss"] = {
    name = "+ripgrep search",
    f = { "<cmd>lua require('spectre').open()<cr>", "files" },
    b = { "<cmd>lua require('spectre').open_file_search()<cr>", "buffers" },
    w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "selected word" },
  }
end

return M
