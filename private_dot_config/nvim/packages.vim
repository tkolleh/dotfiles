try
    " Normally this if-block is not needed, because `:set nocp` is done
    " automatically when .vimrc is found. However, this might be useful
    " when you execute `vim -u .vimrc` from the command line.
    if &compatible
      " `:set nocp` has many side effects. Therefore this should be done
      " only when 'compatible' is set.
      set nocompatible
    endif
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
" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})

command! PackUpdate call minpac#update()
command! PackClean  call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

echomsg "Info: minpac initialized, adding packages..."

call minpac#add('tpope/vim-dadbod', {'type': 'opt'})
call minpac#add('tpope/vim-unimpaired', {'type': 'opt'})
call minpac#add('tpope/vim-commentary', {'type': 'opt'})
call minpac#add('tpope/vim-fugitive', {'type': 'opt'})
call minpac#add('tpope/vim-obsession', {'type': 'opt'})
call minpac#add('tpope/vim-rhubarb', {'type': 'opt'})
call minpac#add('tpope/vim-surround', {'type': 'opt'})
call minpac#add('wellle/targets.vim', {'type': 'opt'})
call minpac#add('vim-scripts/vim-auto-save', {'type': 'opt'})
call minpac#add('skywind3000/asyncrun.vim', {'type': 'opt'})
call minpac#add('skywind3000/asynctasks.vim', {'type': 'opt'})
call minpac#add('junegunn/fzf', {'type': 'opt'})
call minpac#add('junegunn/fzf.vim', {'type': 'opt'})
call minpac#add('mhinz/vim-grepper', {'type': 'opt'})
call minpac#add('francoiscabrol/ranger.vim', {'type': 'opt'})
call minpac#add('rbgrouleff/bclose.vim', {'type': 'opt'})
call minpac#add('airblade/vim-gitgutter', {'type': 'opt'})
call minpac#add('w0rp/ale', {'type': 'opt'})
call minpac#add('neovim/nvim-lspconfig', {'type': 'opt'})
call minpac#add('nvim-lua/diagnostic-nvim', {'type': 'opt'})
call minpac#add('nvim-lua/completion-nvim', {'type': 'opt'})
call minpac#add('mfussenegger/nvim-dap', {'type': 'opt'})
call minpac#add('nvim-treesitter/nvim-treesitter', {'type': 'opt'})
call minpac#add('theHamsta/nvim-dap-virtual-text', {'type': 'opt'})
call minpac#add('sheerun/vim-polyglot', {'type': 'opt'})
call minpac#add('vim-pandoc/vim-pandoc-syntax', {'type': 'opt'})
call minpac#add('vim-pandoc/vim-pandoc', {'type': 'opt'})
call minpac#add('reasonml-editor/vim-reason-plus', {'type': 'opt'})
call minpac#add('ryanoasis/vim-devicons', {'type': 'opt'})
call minpac#add('lifepillar/vim-solarized8', {'type': 'opt'})
call minpac#add('vim-airline/vim-airline', {'type': 'opt'})
call minpac#add('vim-airline/vim-airline-themes', {'type': 'opt'})
call minpac#add('junegunn/goyo.vim', {'type': 'opt'})
call minpac#add('junegunn/limelight.vim', {'type': 'opt'})
call minpac#add('christoomey/vim-tmux-navigator', {'type': 'opt'})
call minpac#add('nathanaelkane/vim-indent-guides', {'type': 'opt'})
call minpac#add('godlygeek/tabular', {'type': 'opt'})
call minpac#add('dhruvasagar/vim-table-mode', {'type': 'opt'})
call minpac#add('alok/notational-fzf-vim', {'type': 'opt'})
call minpac#add('will133/vim-dirdiff', {'type': 'opt'})
