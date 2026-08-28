return {
  "tkolleh/zk-nvim", -- fork: pulls in fix for #300 (ZkIndex crash) ahead of upstream
  opts = {},
  config = function(_, opts)
    local zk = require("zk")
    local zk_config = require("zk.config")
    local commands = require("zk.commands")

    zk.setup({
      -- Can be "telescope", "fzf", "fzf_lua", "minipick", "snacks_picker",
      -- or "select" (`vim.ui.select`).
      -- Note: "fzf" requires junegunn/fzf.vim, use "fzf_lua" for ibhagwan/fzf-lua
      picker = "fzf_lua",
      lsp = {
        -- `config` is passed to `vim.lsp.start(config)`
        config = {
          name = "zk",
          cmd = { "zk", "lsp" },
          filetypes = { "markdown" },
          -- on_attach = ...
          -- etc, see `:h vim.lsp.start()`
        },
        -- zk-nvim's own auto_attach only uses notebook_root() to decide *whether*
        -- to attach; it never feeds that path into the LSP client's root_dir, so
        -- vim.lsp.start() falls back to the buffer's own directory (Neovim core
        -- default when root_dir is unset). That breaks wikilink/definition
        -- resolution for any note outside the buffer's immediate folder. Disable
        -- the plugin's auto_attach and drive it ourselves with a real root_dir.
        auto_attach = {
          enabled = false,
        },
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(args)
        local notebook_root = require("zk.util").notebook_root(vim.api.nvim_buf_get_name(args.buf))
        if not notebook_root then
          return
        end
        vim.lsp.start(vim.tbl_extend("force", zk_config.options.lsp.config, {
          root_dir = notebook_root,
        }), { bufnr = args.buf })
      end,
    })

    -- Custom Commands
    ---List notes sorted by last modified date descending
    commands.add("ZkNotes", function(options)
      options = vim.tbl_extend("force", { sort = { "modified" } }, options or {})
      zk.edit(options, { title = "Zk Notes" })
    end)

    ---Create or open today's daily note
    commands.add("ZkDaily", function(options)
      options = vim.tbl_extend("force", { group = "daily", dir = "journals/daily" }, options or {})
      zk.new(options)
    end)

    ---Browse all daily notes sorted by date descending
    ---@param options? table Optional fzf-lua overrides
    commands.add("ZkDailyNotes", function(options)
      options = options or {}
      local fzf_lua = require("fzf-lua")
      local actions = require("fzf-lua.actions")

      local delimiter = "\x01"

      -- Check if zk command will work (validates notebook context)
      local test_result = vim.fn.system("zk list journals/daily --limit 1 --quiet 2>&1")
      if vim.v.shell_error ~= 0 then
        vim.notify(
          "ZkDailyNotes: Not in a zk notebook. Set ZK_NOTEBOOK_DIR or navigate to a notebook directory.",
          vim.log.levels.ERROR
        )
        return
      end

      -- Let zk auto-detect notebook via ZK_NOTEBOOK_DIR or current directory
      local cmd =
        string.format("zk list journals/daily --sort created- --format '{{abs-path}}%s{{title}}' --quiet", delimiter)

      ---Extract absolute path from entry string
      ---@param entry string
      ---@return string
      local function extract_path(entry)
        return entry:match("([^" .. delimiter .. "]+)")
      end

      fzf_lua.fzf_exec(
        cmd,
        vim.tbl_deep_extend("force", {
          prompt = "Daily Notes> ",
          fzf_opts = {
            ["--delimiter"] = delimiter,
            ["--with-nth"] = "2",
            ["--tiebreak"] = "index",
            ["--preview"] = "mdcat --local {1}",
            ["--preview-window"] = "right:50%:wrap",
            ["--multi"] = "",
          },
          actions = {
            ["default"] = function(selected)
              local paths = vim.tbl_map(extract_path, selected)
              actions.file_edit(paths, {})
            end,
            ["ctrl-s"] = function(selected)
              local paths = vim.tbl_map(extract_path, selected)
              actions.file_split(paths, {})
            end,
            ["ctrl-v"] = function(selected)
              local paths = vim.tbl_map(extract_path, selected)
              actions.file_vsplit(paths, {})
            end,
            ["ctrl-t"] = function(selected)
              local paths = vim.tbl_map(extract_path, selected)
              actions.file_tabedit(paths, {})
            end,
          },
        }, options.fzf_lua or {})
      )
    end)
  end,
}
