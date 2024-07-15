local M = {}

M.chezmoi = function()
-- Configure vim to run chezmoi apply when a dotfile is saved
-- source: https://github.com/xvzc/chezmoi.nvim?tab=readme-ov-file#treat-all-files-in-chezmoi-source-directory-as-chezmoi-files
  if vim.fn.executable('chezmoi') == 1 then
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
      callback = function()
        vim.schedule(require("chezmoi.commands.__edit").watch)
      end,
    })
  end
end

M.hocon = function()
  local hocon_group = vim.api.nvim_create_augroup("hocon", { clear = true })
  vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    group = hocon_group,
    pattern = '*.conf',
    command = 'set ft=hocon'
  })
end

M.drools = function()
  local drools_group = vim.api.nvim_create_augroup("drools", {clear = true})
  vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    group = drools_group,
    pattern = { '*.drl', '*.rdrl' },
    command = 'set ft=drools'
  })
end

return M
