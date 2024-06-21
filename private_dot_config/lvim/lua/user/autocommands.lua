local M = {}

M.chezmoi = function()
-- Configure vim to run chezmoi apply when a dotfile is saved
-- source: https://www.chezmoi.io/user-guide/tools/editor/#configure-vim-to-run-chezmoi-apply-whenever-you-save-a-dotfile
  if vim.fn.executable('chezmoi') == 1 then
    vim.api.nvim_create_augroup('Chezmoi', {
      event = 'BufWritePost',
      pattern = '~/.local/share/chezmoi/*',
      command = [[silent! chezmoi apply --source-path "%"]],
      desc = 'apply dotfiles modifications with chezmoi if executable',
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
