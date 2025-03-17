--
-- neo-tree, for getting context on where you are
-- prefer mini.files for manipulating files
-- https://github.com/nvim-neo-tree/neo-tree.nvim
--
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = true,
    config = function()
      local function open_grug_far(prefills)
        local grug_far = require("grug-far")

        if not grug_far.has_instance("explorer") then
          grug_far.open({ instanceName = "explorer" })
        else
          grug_far.open_instance("explorer")
        end
        -- doing it seperately because multiple paths doesn't open work when passed with open
        -- updating the prefills without clearing the search and other fields
        grug_far.update_instance_prefills("explorer", prefills, false)
      end
      require("neo-tree").setup({
        commands = {
          -- create a new neo-tree command
          grug_far_replace = function(state)
            local node = state.tree:get_node()
            local prefills = {
              -- also escape the paths if space is there
              -- if you want files to be selected, use ':p' only, see filename-modifiers
              paths = node.type == "directory" and vim.fn.fnameescape(vim.fn.fnamemodify(node:get_id(), ":p"))
                or vim.fn.fnameescape(vim.fn.fnamemodify(node:get_id(), ":h")),
            }
            open_grug_far(prefills)
          end,
          -- https://github.com/nvim-neo-tree/neo-tree.nvim/blob/fbb631e818f48591d0c3a590817003d36d0de691/doc/neo-tree.txt#L535
          grug_far_replace_visual = function(state, selected_nodes, callback)
            local paths = {}
            for _, node in pairs(selected_nodes) do
              -- also escape the paths if space is there
              -- if you want files to be selected, use ':p' only, see filename-modifiers
              local path = node.type == "directory" and vim.fn.fnameescape(vim.fn.fnamemodify(node:get_id(), ":p"))
                or vim.fn.fnameescape(vim.fn.fnamemodify(node:get_id(), ":h"))
              table.insert(paths, path)
            end
            local prefills = { paths = table.concat(paths, "\n") }
            open_grug_far(prefills)
          end,
        },
        window = {
          mappings = {
            -- map our new command to z
            z = "grug_far_replace",
          },
        },
        -- rest of your config
      })
    end,
    keys = {
      -- I'm using these 2 keyamps already with mini.files, so avoiding conflict
      { "<leader>e", false },
      { "<leader>E", false },

      -- -- When I press <leader>fe I want to show the current file in neo-tree,
      -- -- But if neo-tree is open it, close it, to work like a toggle
      {
        "<leader>fe",
        function()
          local buf_name = vim.api.nvim_buf_get_name(0)
          -- Function to check if NeoTree is open in any window
          local function is_neo_tree_open()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype == "neo-tree" then
                return true
              end
            end
            return false
          end
          -- Check if the current file exists
          if vim.fn.filereadable(buf_name) == 1 or vim.fn.isdirectory(vim.fn.fnamemodify(buf_name, ":p:h")) == 1 then
            if is_neo_tree_open() then
              -- Close NeoTree if it's open
              vim.cmd("Neotree close")
            else
              -- Open NeoTree and reveal the current file
              vim.cmd("Neotree reveal")
            end
          else
            -- If the file doesn't exist, execute the logic for <leader>R
            require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
          end
        end,
        desc = "[P]Toggle current file in NeoTree or open cwd if file doesn't exist",
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
    },
    opts = {
      filesystem = {
        -- Had to disable this option, because when I open neotree it was
        -- jumping around to random dirs when I opened a dir
        follow_current_file = { enabled = false },

        -- ###################################################################
        --                     custom delete command
        -- ###################################################################
        -- Adding custom commands for delete and delete_visual
        -- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/202#issuecomment-1428278234
        commands = {
          -- over write default 'delete' command to 'trash'.
          delete = function(state)
            if vim.fn.executable("trash") == 0 then
              vim.api.nvim_echo({
                { "- Trash utility not installed. Make sure to install it first\n", nil },
                { "- In macOS run `brew install trash`\n", nil },
                { "- Or delete the `custom delete command` section in neo-tree", nil },
              }, false, {})
              return
            end
            local inputs = require("neo-tree.ui.inputs")
            local path = state.tree:get_node().path
            local msg = "Are you sure you want to trash " .. path
            inputs.confirm(msg, function(confirmed)
              if not confirmed then
                return
              end

              vim.fn.system({ "trash", vim.fn.fnameescape(path) })
              require("neo-tree.sources.manager").refresh(state.name)
            end)
          end,
          -- Overwrite default 'delete_visual' command to 'trash' x n.
          delete_visual = function(state, selected_nodes)
            if vim.fn.executable("trash") == 0 then
              vim.api.nvim_echo({
                { "- Trash utility not installed. Make sure to install it first\n", nil },
                { "- In macOS run `brew install trash`\n", nil },
                { "- Or delete the `custom delete command` section in neo-tree", nil },
              }, false, {})
              return
            end
            local inputs = require("neo-tree.ui.inputs")

            -- Function to get the count of items in a table
            local function GetTableLen(tbl)
              local len = 0
              for _ in pairs(tbl) do
                len = len + 1
              end
              return len
            end

            local count = GetTableLen(selected_nodes)
            local msg = "Are you sure you want to trash " .. count .. " files?"
            inputs.confirm(msg, function(confirmed)
              if not confirmed then
                return
              end
              for _, node in ipairs(selected_nodes) do
                vim.fn.system({ "trash", vim.fn.fnameescape(node.path) })
              end
              require("neo-tree.sources.manager").refresh(state.name)
            end)
          end,
        },
        -- ###################################################################
      },
    },
  },
}
