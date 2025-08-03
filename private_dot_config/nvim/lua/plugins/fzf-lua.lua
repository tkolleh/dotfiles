return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    config = function(_, opts)
      if opts[1] == "default-title" then
        -- use the same prompt for all pickers for profile `default-title` and
        -- profiles that use `default-title` as base profile
        local function fix(t)
          t.prompt = t.prompt ~= nil and " " or nil
          for _, v in pairs(t) do
            if type(v) == "table" then
              fix(v)
            end
          end
          return t
        end
        opts = vim.tbl_deep_extend("force", fix(require("fzf-lua.profiles.default-title")), opts)
        opts[1] = nil
      end

      -- Display the filename first in the results
      opts.default = vim.tbl_deep_extend("force", opts.default or {}, {
        formatter= { "path.filename_first",2}
      })

      opts.grep = vim.tbl_deep_extend("force", opts.grep or {}, {
        formatter = "path.filename_first",
        rg_opts   = "--no-ignore-dot --no-ignore-exclude --no-ignore --hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
      })

      -- Use the ivy layout and fzf-native sorter if not already set
      opts = vim.tbl_extend("keep", opts, { "ivy", "fzf-native" })

      require("fzf-lua").setup(opts)
    end,
  },
}
