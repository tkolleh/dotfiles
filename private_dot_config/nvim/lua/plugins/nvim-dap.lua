local scala = require("languages.scala")

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "theHamsta/nvim-dap-virtual-text",
  },
  opts = function()
    local dap = require("dap")

    -- Define scala debug adapter and configuration
    dap.adapters.scala = scala.dap.adapters.base
    dap.configurations.scala = scala.dap.configurations.scala

    -- Zig debug adapter configuration
    -- Uses codelldb (LLDB-based debug adapter) for Zig debugging
    if not dap.adapters.codelldb then
      dap.adapters.codelldb = {
        type = "executable",
        command = "codelldb",
        -- Alternatively, use server type for older codelldb versions
        -- type = "server",
        -- port = "${port}",
        -- executable = {
        --   command = "codelldb",
        --   args = { "--port", "${port}" },
        -- },
      }
    end

    if not dap.configurations.zig then
      dap.configurations.zig = {
        {
          name = "Debug Zig",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          terminal = "integrated",
        },
        {
          name = "Debug Zig with args",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " +")
          end,
          cwd = "${workspaceFolder}",
        },
      }
    end

    -- Also configure Zig to use the same adapter for simplicity
    if not dap.adapters.zig then
      dap.adapters.zig = dap.adapters.codelldb
    end
  end,
  config = function()
    local function setup_dap_commands()
      local function set_breakpoint_optional()
        vim.ui.input({ prompt = "Condition: " }, function(cond)
          if cond == nil then
            return
          end
          if cond == "" then
            cond = nil
          end

          vim.ui.input({ prompt = "Hit condition: " }, function(hit)
            if hit == nil then
              return
            end
            if hit == "" then
              hit = nil
            end

            vim.ui.input({ prompt = "Log point: " }, function(log)
              if log == nil then
                return
              end
              if log == "" then
                log = nil
              end

              require("dap").set_breakpoint(cond, hit, log)
            end)
          end)
        end)
      end
      vim.api.nvim_create_user_command("DapListBreakPoints", function()
        require("dap").list_breakpoints()
        local ok = pcall(function()
          vim.cmd("Trouble qflist open")
        end)
        if not ok then
          pcall(function()
            vim.cmd("Trouble quickfix")
          end)
        end
      end, { desc = "List DAP breakpoints in Trouble" })
      vim.api.nvim_create_user_command("DapSetBreakpointCondition", function()
        vim.ui.input({ prompt = "Condition: " }, function(cond)
          if cond == nil or cond == "" then
            return
          end
          require("dap").set_breakpoint(cond)
        end)
      end, { desc = "Set breakpoint with condition" })
      vim.api.nvim_create_user_command("DapSetBreakpointHitCondition", function()
        vim.ui.input({ prompt = "Hit condition: " }, function(hit)
          if hit == nil or hit == "" then
            return
          end
          require("dap").set_breakpoint(nil, hit)
        end)
      end, { desc = "Set breakpoint with hit condition" })
      vim.api.nvim_create_user_command("DapSetBreakpointLogPoint", function()
        vim.ui.input({ prompt = "Log point: " }, function(log)
          if log == nil or log == "" then
            return
          end
          require("dap").set_breakpoint(nil, nil, "LogPoint hit: " .. log)
        end)
      end, { desc = "Set breakpoint with log message" })
      vim.api.nvim_create_user_command("DapSetBreakpointComplex", function()
        set_breakpoint_optional()
      end, { desc = "Set breakpoint with optional condition, hit count, and log message" })
    end

    local function enhance_breakpoint_hl()
      local function apply_hl()
        -- Get LazyVim's DAP icon configuration (if available)
        local lazyvim_icons = LazyVim and LazyVim.config and LazyVim.config.icons and LazyVim.config.icons.dap
        local breakpoint_icon = lazyvim_icons and lazyvim_icons.Breakpoint or " "

        -- Get current sign definition to preserve linehl/numhl if they exist
        local signs = vim.fn.sign_getdefined("DapBreakpoint")
        local current_sign = signs and signs[1] or {}
        local linehl = current_sign.linehl or nil
        local numhl = current_sign.numhl or nil

        -- Calculate enhanced highlight (only color changes, icon stays same)
        local hl = vim.api.nvim_get_hl(0, { name = "DapBreakpoint", link = false })
        local fg = hl.fg
        if not fg then
          local error_hl = vim.api.nvim_get_hl(0, { name = "ErrorMsg", link = false })
          fg = error_hl.fg or 0xFF0000
        end

        local r = bit.rshift(bit.band(fg, 0xFF0000), 16)
        local g = bit.rshift(bit.band(fg, 0x00FF00), 8)
        local b = bit.band(fg, 0x0000FF)

        r = math.min(255, math.floor(r * 1.5 + 50))
        g = math.floor(g * 0.8)
        b = math.floor(b * 0.8)

        local new_fg = string.format("#%02X%02X%02X", r, g, b)

        vim.api.nvim_set_hl(0, "DapBreakpointEnhanced", { fg = new_fg, bg = hl.bg, bold = true })

        -- Redefine sign with LazyVim's icon and enhanced highlight
        vim.fn.sign_define("DapBreakpoint", {
          text = breakpoint_icon,
          texthl = "DapBreakpointEnhanced",
          linehl = linehl,
          numhl = numhl,
        })

        -- Also ensure other DAP signs are defined with LazyVim's icons
        -- This prevents them from using nvim-dap's default "B", "C", "R" text
        if lazyvim_icons then
          for name, sign in pairs(lazyvim_icons) do
            if name ~= "Breakpoint" then -- Breakpoint already handled above
              sign = type(sign) == "table" and sign or { sign }
              local other_signs = vim.fn.sign_getdefined("Dap" .. name)
              local other_current = other_signs and other_signs[1] or {}
              vim.fn.sign_define("Dap" .. name, {
                text = sign[1],
                texthl = sign[2] or "DiagnosticInfo",
                linehl = other_current.linehl or sign[3],
                numhl = other_current.numhl or sign[3],
              })
            end
          end
        end
      end

      -- Use defer to ensure everything is initialized
      vim.defer_fn(function()
        apply_hl()

        -- Auto-reapply on colorscheme change
        local group = vim.api.nvim_create_augroup("DapBreakpointEnhancement", { clear = true })
        vim.api.nvim_create_autocmd("ColorScheme", {
          group = group,
          callback = apply_hl,
        })
      end, 10) -- 10ms delay
    end

    setup_dap_commands()
    enhance_breakpoint_hl()
  end,
}
