scriptencoding utf-8

try
    packadd minpac
catch /.*/
  if has('nvim')
    "
    " If missing, download minpac and install all plugins.
    "
    if empty(glob($XDG_CONFIG_HOME.'/nvim/pack/minpac/opt/minpac'))
      silent !mkdir -p $XDG_CONFIG_HOME/nvim/pack/minpac/opt/minpac
      silent !curl -sfL https://github.com/k-takata/minpac/archive/master.zip | tar --strip-components=1 -zxf - -C $XDG_CONFIG_HOME/nvim/pack/minpac/opt/minpac
      augroup installplug
        autocmd!
        autocmd VimEnter * packadd minpac --sync | call minpac#init() | source $MYVIMRC
      augroup end
    endif
  endif
endtry

call minpac#init({'verbose': 3, 'progress_open': 'vertical','status_open': 'vertical'})
call minpac#add('k-takata/minpac', {'type': 'start'})

command! PackUpdate call minpac#update()
command! PackClean  call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

" echomsg "Info: minpac initialized, adding packages..."

call minpac#add('tpope/vim-dadbod', {'type': 'start'})
call minpac#add('tpope/vim-unimpaired', {'type': 'start'})
call minpac#add('tpope/vim-commentary', {'type': 'start'})
call minpac#add('tpope/vim-fugitive', {'type': 'start'})
call minpac#add('tpope/vim-obsession', {'type': 'start'})
call minpac#add('tpope/vim-rhubarb', {'type': 'start'})
call minpac#add('tpope/vim-surround', {'type': 'start'})
call minpac#add('wellle/targets.vim', {'type': 'start'})
call minpac#add('vim-scripts/vim-auto-save', {'type': 'start'})
call minpac#add('skywind3000/asyncrun.vim', {'type': 'start'})
call minpac#add('skywind3000/asynctasks.vim', {'type': 'start'})
call minpac#add('junegunn/fzf', {'type': 'start'})
call minpac#add('junegunn/fzf.vim', {'type': 'start'})
call minpac#add('mhinz/vim-grepper', {'type': 'start'})
call minpac#add('francoiscabrol/ranger.vim', {'type': 'start'})
call minpac#add('rbgrouleff/bclose.vim', {'type': 'start'})
call minpac#add('airblade/vim-gitgutter', {'type': 'start'})
call minpac#add('neovim/nvim-lspconfig', {'type': 'start'})
call minpac#add('nvim-treesitter/nvim-treesitter', {'type': 'start', 'do': 'silent! TSUpdate'})
call minpac#add('nvim-treesitter/nvim-treesitter-refactor', {'type': 'start'})
call minpac#add('romgrk/nvim-treesitter-context', {'type': 'start'})
call minpac#add('nvim-lua/completion-nvim', {'type': 'start'})
call minpac#add('nvim-treesitter/completion-treesitter', {'type': 'start'})
call minpac#add('mfussenegger/nvim-dap', {'type': 'start'})
call minpac#add('theHamsta/nvim-dap-virtual-text', {'type': 'start'})
call minpac#add('sheerun/vim-polyglot', {'type': 'opt'})
call minpac#add('vim-pandoc/vim-pandoc-syntax', {'type': 'start'})
call minpac#add('vim-pandoc/vim-pandoc', {'type': 'start'})
call minpac#add('reasonml-editor/vim-reason-plus', {'type': 'start'})
call minpac#add('ryanoasis/vim-devicons', {'type': 'start'})
call minpac#add('lifepillar/vim-solarized8', {'type': 'start'})
call minpac#add('lourenci/github-colors', {'type': 'start'})
call minpac#add('vim-airline/vim-airline', {'type': 'start'})
call minpac#add('vim-airline/vim-airline-themes', {'type': 'start'})
call minpac#add('junegunn/goyo.vim', {'type': 'start'})
call minpac#add('junegunn/limelight.vim', {'type': 'start'})
call minpac#add('christoomey/vim-tmux-navigator', {'type': 'start'})
call minpac#add('nathanaelkane/vim-indent-guides', {'type': 'start'})
call minpac#add('godlygeek/tabular', {'type': 'start'})
call minpac#add('dhruvasagar/vim-table-mode', {'type': 'start'})
call minpac#add('alok/notational-fzf-vim', {'type': 'start'})
call minpac#add('will133/vim-dirdiff', {'type': 'start'})
call minpac#add('sbdchd/neoformat', {'type': 'start'})
call minpac#add('editorconfig/editorconfig-vim', {'type': 'start'})
call minpac#add('steelsojka/completion-buffers', {'type': 'start'})
call minpac#add('goerz/jupytext.vim', {'type': 'start'})
call minpac#add('jupyter-vim/jupyter-vim', {'type': 'opt'})
call minpac#add('SirVer/ultisnips', {'type': 'opt'})
call minpac#add('honza/vim-snippets', {'type': 'opt'})
call minpac#add('tkolleh/conoline.vim', {'type': 'start'})
call minpac#add('knsh14/vim-github-link', {'type': 'start'})
