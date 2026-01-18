return {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    opts = function(_, opts)
      opts = opts or {}

      -- Base profiles
      -- Use fzf's native previewing, using `bat` for previews
      -- UI at bottom, similar to telescope's ivy layout
      table.insert(opts, 1, { "ivy", "fzf-native" })

      opts["previewers"] = vim.tbl_deep_extend("force", opts.previewers or {}, {
        bat = {
          cmd  = "bat",
          args = "--color=always --style=numbers,changes --theme auto:system --theme-dark Dracula --theme-light GitHub",
        }
      })

      -- Display the filename first in the results
      opts["defaults"] = vim.tbl_deep_extend("force", opts.defaults or {}, {
        formatter = { "path.filename_first",2}
      })

      -- Preview in dark or light mode based on system settings
      opts["winopts"] = opts.winopts or {}
      opts.winopts["preview"] = vim.tbl_deep_extend("force", opts.winopts.preview or {}, {
        default="bat"
      })

      opts["files"] = vim.tbl_deep_extend("force", opts.files or {}, {
        -- Rounded borders and word wrap for files preview windows
        winopts = {
          border = "rounded",
          preview = {
            border = "rounded",
            wrap = true,
          },
        },
      })

      opts["grep"] = vim.tbl_deep_extend("force", opts.grep or {}, {
        formatter = "path.filename_first",
        rg_opts   = "--no-ignore-dot --no-ignore-exclude --no-ignore --hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
        -- Rounded borders and word wrap for grep preview windows
        winopts = {
          border = "rounded",
          preview = {
            border = "rounded",
            wrap = true,
          },
        },
      })

      opts["buffers"] = vim.tbl_deep_extend("force", opts.buffers or {}, {
        formatter = "path.filename_first",
        -- Rounded borders and word wrap for buffers preview windows
        winopts = {
          border = "rounded",
          preview = {
            border = "rounded",
            wrap = true,
          },
        },
      })

      return opts
    end,
}
