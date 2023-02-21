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

return M
