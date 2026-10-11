-- Customize cokeline
--
-- Icon and text backgrounds reference named `Cokeline*` groups maintained by
-- monrovia (lua/monrovia/group/modules/cokeline.lua) rather than `fg`/`bg`
-- functions, so they stay colorscheme-aware: monrovia repaints those groups
-- on every `ColorScheme`/`BufEnter`, matching the same per-filetype icon
-- coloring it already provides for bufferline.nvim.
local function devicon_hl_name(buffer)
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then
    return nil
  end
  local ext = vim.fn.fnamemodify(buffer.path or "", ":e")
  local _, hl_name = devicons.get_icon(buffer.filename or "", ext, { default = true })
  return hl_name
end

return {
  "willothy/nvim-cokeline",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    fill_hl = "CokelineFill",
    components = {
      {
        text = function(buffer)
          return " " .. buffer.devicon.icon .. " "
        end,
        highlight = function(buffer)
          local hl_name = devicon_hl_name(buffer)
          if not hl_name then
            return buffer.is_focused and "CokelineDevIconDefaultSelected" or "CokelineDevIconDefault"
          end
          return "Cokeline" .. hl_name .. (buffer.is_focused and "Selected" or "")
        end,
      },
      {
        text = function(buffer)
          return buffer.filename .. " "
        end,
        highlight = function(buffer)
          return buffer.is_focused and "CokelineBufferSelected" or "CokelineBuffer"
        end,
      },
      {
        text = "󰅖",
        highlight = function(buffer)
          return buffer.is_focused and "CokelineCloseButtonSelected" or "CokelineCloseButton"
        end,
        on_click = function(_, _, _, _, buffer)
          buffer:delete()
        end,
      },
      {
        text = " ",
        highlight = function(buffer)
          return buffer.is_focused and "CokelineBufferSelected" or "CokelineBuffer"
        end,
      },
    },
  },
}
