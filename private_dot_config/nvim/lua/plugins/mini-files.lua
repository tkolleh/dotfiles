--
-- https://github.com/echasnovski/mini.files
--
return {
  "echasnovski/mini.files",
  enabled = false,
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts or {}, {
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 80,
      },
      options = {
        -- Whether to use for editing directories
        -- Disabled by default in LazyVim because neo-tree is used for that
        use_as_default_explorer = false,
      },
    })
  end,
  keys = function(_, opts)
    return vim.tbl_deep_extend("force", opts or {}, {
      {
        -- open the directory of the file currently being edited
        -- if the file doesn't exist because you maybe switched to a new git branch
        -- open the current working directory
        "<leader>e",
        function()
          local buf_name = vim.api.nvim_buf_get_name(0)
          local dir_name = vim.fn.fnamemodify(buf_name, ":p:h")
          if vim.fn.filereadable(buf_name) == 1 then
            -- Pass the full file path to highlight the file
            require("mini.files").open(buf_name, true)
          elseif vim.fn.isdirectory(dir_name) == 1 then
            -- If the directory exists but the file doesn't, open the directory
            require("mini.files").open(dir_name, true)
          else
            -- If neither exists, fallback to the current working directory
            require("mini.files").open(vim.uv.cwd(), true)
          end
        end,
        desc = "Open mini.files (Directory of Current File)",
      },
      {
        "<leader>E",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        desc = "Open mini.files (cwd)",
      },
    })
  end,
}
