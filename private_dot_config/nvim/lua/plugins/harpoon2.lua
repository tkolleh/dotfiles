-- Override Harpoon2 configuration to limit which-key entries to 3 files
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  opts = function(_, opts)
    opts.settings = opts.settings or {}
    opts.settings.save_on_toggle = true
    return opts
  end,
  keys = function()
    local keys = {
      {
        "<leader>H",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon File",
      },
      {
        "<leader>h",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
    }

    -- Only create keybindings for files 1-3
    for i = 1, 3 do
      table.insert(keys, {
        "<leader>" .. i,
        function()
          require("harpoon"):list():select(i)
        end,
        desc = "Harpoon to File " .. i,
      })
    end
    return keys
  end,
}
