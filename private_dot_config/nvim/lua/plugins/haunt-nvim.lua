---Get haunt's context hash from storage path
---@return string hash 12-character context hash
local function get_context_hash()
  local persistence = require("haunt.persistence")
  local storage_path = persistence.get_storage_path()
  return vim.fn.fnamemodify(storage_path, ":t:r")
end

---Convert string to snake_case
---@param str string Input string (CamelCase, PascalCase, kebab-case, etc.)
---@return string snake_case Converted string in snake_case
local function to_snake_case(str)
  local snake = str
    :gsub("([a-z0-9])([A-Z])", "%1_%2") -- myCamel1Case -> my_Camel1_Case
    :gsub("([A-Z]+)([A-Z][a-z])", "%1_%2") -- XMLHttp -> XML_Http
    :gsub("%-", "_") -- kebab-case -> kebab_case
    :gsub("[^%w_]", "_") -- replace other special chars with underscore
    :gsub("_+", "_") -- collapse multiple underscores
    :gsub("^_", "") -- remove leading underscore
    :gsub("_$", "") -- remove trailing underscore
    :lower()
  return snake
end

---Get snake_case filename for zk note naming
---@param filepath string Absolute path to source file
---@return string slug Filename without extension in snake_case
local function get_source_file_slug(filepath)
  local filename = vim.fn.fnamemodify(filepath, ":t:r") -- filename without extension
  return to_snake_case(filename)
end

---Format bookmarks for a single file as Markdown content with IDs
---@param bookmarks table[] Array of bookmark objects for one file
---@param filepath string The source file path
---@return string markdown Formatted markdown content
local function format_file_bookmarks_as_markdown(bookmarks, filepath)
  local lines = {}
  local relative_path = vim.fn.fnamemodify(filepath, ":~:.")
  local timestamp = os.date("%Y-%m-%d %H:%M")

  table.insert(lines, "")
  table.insert(lines, string.format("## Export: %s", timestamp))
  table.insert(lines, "")
  table.insert(lines, string.format("**Source:** `%s`", relative_path))
  table.insert(lines, "")

  -- Sort by line number
  table.sort(bookmarks, function(a, b)
    return a.line < b.line
  end)

  for _, bm in ipairs(bookmarks) do
    table.insert(lines, string.format("### Line %d", bm.line))
    table.insert(lines, "")
    if bm.note and bm.note ~= "" then
      table.insert(lines, string.format("> %s", bm.note))
      table.insert(lines, "")
    end
    table.insert(lines, string.format("**ID:** `%s`", bm.id))
    table.insert(lines, "")
    table.insert(lines, "---")
    table.insert(lines, "")
  end

  return table.concat(lines, "\n")
end

---Check if a zk note exists and append content, or create new
---@param note_path string Full path to the note file
---@param content string Content to append
---@param create_opts table Options for creating new note via zk.new()
local function append_or_create_note(note_path, content, create_opts)
  local zk = require("zk")

  if vim.fn.filereadable(note_path) == 1 then
    -- Note exists: append content
    local file = io.open(note_path, "a")
    if file then
      file:write(content)
      file:close()
      vim.cmd("edit " .. note_path)
      vim.notify("Appended annotations to existing note", vim.log.levels.INFO, { title = "Haunt Export" })
    else
      vim.notify("Failed to open note for appending", vim.log.levels.ERROR, { title = "Haunt Export" })
    end
  else
    -- Note doesn't exist: create new via zk
    zk.new(create_opts)
  end
end

---Export haunt annotations to zk notes (one per file)
---@param opts? { current_buffer?: boolean }
local function export_to_zk(opts)
  opts = opts or {}

  -- Pre-flight check 1: zk-nvim available
  local zk_ok, _ = pcall(require, "zk")
  if not zk_ok then
    vim.notify("zk-nvim not available", vim.log.levels.ERROR, { title = "Haunt Export" })
    return
  end

  -- Pre-flight check 2: resolve notebook path
  local zk_util = require("zk.util")
  local notebook_path = zk_util.resolve_notebook_path(0)
  if not notebook_path then
    vim.notify("Could not resolve notebook path", vim.log.levels.ERROR, { title = "Haunt Export" })
    return
  end

  local notebook_root = zk_util.notebook_root(notebook_path)
  if not notebook_root then
    vim.notify("Not in a zk notebook", vim.log.levels.ERROR, { title = "Haunt Export" })
    return
  end

  -- Pre-flight check 3: bookmarks exist
  local haunt_api = require("haunt.api")
  local bookmarks = haunt_api.get_bookmarks()

  if #bookmarks == 0 then
    vim.notify("No annotations to export", vim.log.levels.WARN, { title = "Haunt Export" })
    return
  end

  -- Filter to current buffer if requested
  if opts.current_buffer then
    local current_file = vim.fn.expand("%:p")
    bookmarks = vim.tbl_filter(function(b)
      return b.file == current_file
    end, bookmarks)

    if #bookmarks == 0 then
      vim.notify("No annotations in current buffer", vim.log.levels.WARN, { title = "Haunt Export" })
      return
    end
  end

  -- Group bookmarks by file
  local by_file = {}
  for _, bm in ipairs(bookmarks) do
    if not by_file[bm.file] then
      by_file[bm.file] = {}
    end
    table.insert(by_file[bm.file], bm)
  end

  -- Get context info
  local context_hash = get_context_hash()
  local git_info = require("haunt.persistence").get_git_info()
  local project = git_info.root and vim.fn.fnamemodify(git_info.root, ":t") or "unknown"
  local branch = git_info.branch or "default"

  local files = vim.tbl_keys(by_file)
  local file_count = #files
  local total_bookmarks = #bookmarks

  -- Export each file's annotations to its own note
  for _, filepath in ipairs(files) do
    local file_bookmarks = by_file[filepath]
    local source_file_slug = get_source_file_slug(filepath)
    local filename = vim.fn.fnamemodify(filepath, ":t")
    local note_filename = context_hash .. "_" .. source_file_slug .. ".md"
    local note_path = notebook_root .. "/annotations/" .. note_filename

    local content = format_file_bookmarks_as_markdown(file_bookmarks, filepath)
    local title = string.format("Annotations - %s", filename)

    local create_opts = {
      title = title,
      dir = "annotations",
      extra = {
        context_hash = context_hash,
        source_file = source_file_slug,
        project = project,
        branch = branch,
      },
      content = content,
      insertContentAtLocation = { row = 0, col = 0 },
      edit = (file_count == 1), -- Only open editor if single file
    }

    append_or_create_note(note_path, content, create_opts)
  end

  if file_count > 1 then
    vim.notify(
      string.format("Exported %d annotations across %d files", total_bookmarks, file_count),
      vim.log.levels.INFO,
      { title = "Haunt Export" }
    )
  end
end

return {
  "TheNoeTrevino/haunt.nvim",
  enabled = true,
  opts = {
    picker = "fzf",
    sign_hl = "Comment",
    virt_text_hl = "Comment",
  },
  config = function(_, opts)
    require("haunt").setup(opts)

    -- Create user command for export
    vim.api.nvim_create_user_command("HauntExportToZk", function(cmd_opts)
      export_to_zk({ current_buffer = cmd_opts.bang })
    end, {
      bang = true,
      desc = "Export haunt annotations to zk (! for current buffer only)",
    })
  end,
  keys = {
    {
      "<leader>hh",
      "<cmd>HauntAnnotate<cr>",
      desc = "Annotate",
    },
    {
      "<leader>hH",
      "<cmd>HauntDelete<cr>",
      desc = "Remove Annotation",
    },
    {
      "<leader>ht",
      "<cmd>HauntToggle<cr>",
      desc = "Toggle Annotation",
    },
    {
      "<leader>hT",
      function()
        require("haunt.api").toggle_all_lines()
      end,
      desc = "Toggle All Annotation",
    },
    {
      "<leader>hs",
      function()
        require("haunt.picker").show()
      end,
      desc = "Select Annotation",
    },
    {
      "<leader>he",
      "<cmd>HauntExportToZk<cr>",
      desc = "Export annotations to zk",
    },
    {
      "<leader>hE",
      "<cmd>HauntExportToZk!<cr>",
      desc = "Export buffer annotations to zk",
    },
  },
}
