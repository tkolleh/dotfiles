return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)

    -- Custom LSP status component (Neovim 0.11+ compatible)
    -- Displays LSP server names (e.g., " lua_ls, metals") or falls back to " LSP (n)"
    -- when the string exceeds max_width. Filters out utility servers.
    local lsp_status = {
      function()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({ bufnr = bufnr })

        -- Filter out utility/assistant servers (hash table for O(1) lookup)
        local ignore_list = {
          ["null-ls"] = true,
          ["copilot"] = true,
          ["GitHub Copilot"] = true,
          ["conform"] = true,
          ["none-ls"] = true,
          ["efm"] = true,
        }

        -- Collect non-ignored client names
        local names = {}
        for _, client in ipairs(clients) do
          if not ignore_list[client.name] then
            table.insert(names, client.name)
          end
        end

        local count = #names
        if count == 0 then
          return ""
        end

        -- Build names string and check width
        local max_width = 30
        local names_str = "" .. table.concat(names, ", ")

        -- Use nvim_strwidth for accurate display width (handles multibyte/emoji)
        if vim.api.nvim_strwidth(names_str) > max_width then
          return " LSP (" .. count .. ")"
        end

        return names_str
      end,
    }

    -- stylua: ignore
    local colors = {
      blue   = '#80a0ff',
      cyan   = '#79dac8',
      black  = '#080808',
      white  = '#c6c6c6',
      red    = '#ff5189',
      violet = '#d183e8',
      grey   = '#303030',
    }

    local bubbles_theme = {
      normal = {
        a = { fg = colors.black, bg = colors.violet },
        b = { fg = colors.white, bg = colors.grey },
        c = { fg = colors.white },
      },

      insert = { a = { fg = colors.black, bg = colors.blue } },
      visual = { a = { fg = colors.black, bg = colors.cyan } },
      replace = { a = { fg = colors.black, bg = colors.red } },

      inactive = {
        a = { fg = colors.white, bg = colors.black },
        b = { fg = colors.white, bg = colors.black },
        c = { fg = colors.white },
      },
    }

    opts['theme'] = vim.tbl_deep_extend('force', opts.theme or {}, bubbles_theme)
    opts['section_separators'] = vim.tbl_deep_extend('force',opts.section_separators or {},{ 
      left = '',
      right = ''
    })
    opts.component_separators = ''

    opts.sections = vim.tbl_deep_extend('force', opts.sections or {}, {
      lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
      lualine_b = { 'filename', 'branch' },
      lualine_c = {
        '%=', --[[ add your center components here in place of this comment ]]
      },
      lualine_x = {},
      lualine_y = { 'filetype', 'progress', lsp_status },
      lualine_z = {
        { 'location', separator = { right = '' }, left_padding = 2 },
      },
    })

    opts.inactive_sections = vim.tbl_deep_extend('force', opts.inactive_sections or {},{
      lualine_a = { 'filename' },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { 'location' },
    })
    return opts
  end,
}

