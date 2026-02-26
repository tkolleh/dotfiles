return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)

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
      lualine_y = { 'filetype', 'progress' },
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

    -- local icon = _G.LazyVim.config.icons
    -- local space = {
    --   function()
    --     return " "
    --   end,
    -- }
    --
    -- local lsp_status = {
    --   "lsp_status",
    --   separator = { left = icon.ui.PowerlineArrowLeft, right = icon.ui.PowerlineRightRounded },
    -- }
    --
    -- local no_servers = {
    --   function()
    --     return "  No servers"
    --   end,
    --   cond = function()
    --     local bufnr = vim.api.nvim_get_current_buf()
    --     local buf_clients = vim.lsp.get_clients({ bufnr = bufnr })
    --     return next(buf_clients) == nil
    --   end,
    --   separator = { left = icon.ui.PowerlineLeftRounded, right = icon.ui.PowerlineRightRounded },
    -- }
    --
    -- local section_z = vim.tbl_deep_extend("force", opts.sections.lualine_z or {}, {
    --   lsp_status,
    --   no_servers,
    -- })
    -- opts.sections.lualine_z = section_z
    return opts
  end,
}

