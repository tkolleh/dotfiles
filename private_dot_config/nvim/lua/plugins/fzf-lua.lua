return {
  "ibhagwan/fzf-lua",
  opts = function(_, opts)
    opts = opts or {}

    -- Keep "default-title" as first profile for LazyVim's special handling
    -- Add ivy and fzf-native profiles after it (applied in order)
    table.insert(opts, 2, "ivy")
    table.insert(opts, 3, "fzf-native")

    -- Ensure automatic color sync with nightfox (already set by extra)
    opts["fzf_colors"] = true

    -- Optimize bat previewer for nightfox compatibility
    opts["previewers"] = vim.tbl_deep_extend("force", opts.previewers or {}, {
      bat = {
        cmd = "bat",
        args = "--color=always --style=numbers,changes --theme=base16",
      },
    })

    -- Use filename-first formatter for deeply nested paths
    opts["defaults"] = vim.tbl_deep_extend("force", opts.defaults or {}, {
      formatter = { "path.filename_first", 2 },
    })

    -- Override winopts to match ivy profile (bottom placement, minimal borders)
    -- Preserve preview scrollchars from LazyVim extra
    opts["winopts"] = vim.tbl_deep_extend("force", opts.winopts or {}, {
      row = 1, -- bottom placement (ivy style)
      col = 0, -- full width
      width = 1, -- full width
      height = 1, -- full height
      -- border is handled by ivy profile's function (minimal snacks-like borders)
      -- DO NOT set border here or it will override ivy's border function
    })

    -- Files search configuration
    -- Note: multiprocess disabled to avoid upvalue serialization errors with closures
    opts["files"] = vim.tbl_deep_extend("force", opts.files or {}, {
      multiprocess = false,
    })

    -- Grep configuration with sensible rg_opts
    -- Note: multiprocess disabled to avoid upvalue serialization errors
    opts["grep"] = vim.tbl_deep_extend("force", opts.grep or {}, {
      formatter = "path.filename_first",
      rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
      multiprocess = false,
    })

    -- Buffers configuration
    -- Note: multiprocess disabled to avoid upvalue serialization errors
    opts["buffers"] = vim.tbl_deep_extend("force", opts.buffers or {}, {
      formatter = "path.filename_first",
      multiprocess = false,
    })

    -- Enhanced undotree - keep existing config but remove border overrides
    opts["undotree"] = vim.tbl_deep_extend("force", opts.undotree or {}, {
      previewer = "undotree_native",
      preview_pager = "delta --no-gitconfig --paging=never --syntax-theme='Solarized (light)' --true-color=always --navigate --line-numbers --features 'unobtrusive-line-numbers decorations' --whitespace-error-style '22 reverse' --width=$FZF_PREVIEW_COLUMNS",
      winopts = {
        preview = {
          wrap = true,
        },
      },
    })

    return opts
  end,
}
