try
  packadd minpac
catch
  if has('nvim')
    "
    " If missing, download minpac and install all plugins.
    "
    if empty(glob($XDG_DATA_HOME.'/nvim/site/autoload/'))
      silent !mkdir -p $XDG_DATA_HOME/nvim/pack/minpac/opt/minpac
      silent !curl -sfL https://github.com/k-takata/minpac/archive/master.zip | tar --strip-components=1 -zxf - -C $XDG_DATA_HOME/nvim/pack/minpac/opt/minpac
      augroup installplug
        autocmd!
        autocmd VimEnter * call minpac#update() --sync | source $MYVIMRC
      augroup end
    endif
  endif
endtry

if exists('*minpac#init') "{{{

call minpac#init()
" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})

call minpac#add('https://github.com/tpope/vim-dadbod.git')
call minpac#add('https://github.com/tpope/vim-unimpaired')
call minpac#add('https://github.com/tpope/vim-commentary.git')
call minpac#add('https://github.com/tpope/vim-fugitive.git')
call minpac#add('https://github.com/tpope/vim-obsession')
call minpac#add('https://github.com/tpope/vim-rhubarb.git')
call minpac#add('https://github.com/tpope/vim-surround.git')
call minpac#add('https://github.com/wellle/targets.vim.git')

call minpac#add('https://github.com/vim-scripts/vim-auto-save')

let g:auto_save = 0                 " disable AutoSave on Vim startup
let g:auto_save_silent = 0          " display the auto-save notification
let g:auto_save_no_updatetime = 1   " do not change the 'updatetime' option
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode

call minpac#add('skywind3000/asyncrun.vim')

" Asyncrun should open quickfix window at provided height 
let g:asyncrun_open = 7
let g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', '.hg', '.idea', '.editorconfig']

  call minpac#add('skywind3000/asynctasks.vim')


call minpac#add('junegunn/fzf')

" [Tags] Command to generate tags file for fzf
let g:fzf_tags_command = '!exec .git/hooks/post-merge'

  call minpac#add('junegunn/fzf.vim')

call minpac#add('mhinz/vim-grepper')
call minpac#add('francoiscabrol/ranger.vim')
  call minpac#add('rbgrouleff/bclose.vim')
call minpac#add('https://github.com/airblade/vim-gitgutter.git')


call minpac#add('https://github.com/neovim/nvim-lspconfig.git')

nnoremap <silent> gi    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gy   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

    call minpac#add('nvim-lua/diagnostic-nvim')

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ''
let g:diagnostic_trimmed_virtual_text = '32'
let g:diagnostic_sign_priority = 20
let g:diagnostic_enable_underline = 0
let g:space_before_virtual_text = 2
let g:diagnostic_insert_delay = 1 " Dont show diagnostics while in insert mode

    call minpac#add('nvim-lua/completion-nvim')
    call minpac#add('https://github.com/theHamsta/nvim-dap-virtual-text.git')


if has('nvim-0.5')
  call minpac#add('https://github.com/mfussenegger/nvim-dap.git')
  call minpac#add('https://github.com/nvim-treesitter/nvim-treesitter.git')
else
  call minpac#add('https://github.com/sheerun/vim-polyglot.git')
endif

call minpac#add('vim-pandoc/vim-pandoc-syntax')
call minpac#add('vim-pandoc/vim-pandoc')

" Pandoc prefer pdf over html default
" Pandoc use citeproc instead of default 'fallback' for bibliography
let g:pandoc#command#prefer_pdf = 0
let g:pandoc#completion#bib#mode = 'citeproc'

call minpac#add('https://github.com/editorconfig/editorconfig-vim.git')
" editor config
" disable for vim fugitive and avoid loading for remote files 
let g:EditorConfig_exclude_patterns = ['fugitive://.\*', 'scp://.\*']
let g:EditorConfig_disable_rules = ['trim_trailing_whitespace']


call minpac#add('https://github.com/reasonml-editor/vim-reason-plus.git')
call minpac#add('ryanoasis/vim-devicons')
call minpac#add('https://github.com/lifepillar/vim-solarized8.git')

call minpac#add('https://github.com/vim-airline/vim-airline.git')
  call minpac#add('https://github.com/vim-airline/vim-airline-themes.git')

let g:airline_powerline_fonts = 1
let g:airline_theme='deus'
let g:webdevicons_enable_airline_statusline = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#obsession#enabled = 1
let g:airline#extensions#obsession#indicator_text = ''

call minpac#add('junegunn/goyo.vim')
call minpac#add('https://github.com/junegunn/limelight.vim.git')

if len($TMUX) > 1
  call minpac#add('https://github.com/christoomey/vim-tmux-navigator.git')
endif

call minpac#add('https://github.com/nathanaelkane/vim-indent-guides.git')

" indent guides configurations
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'text', 'markdown', 'md']
let g:indent_guides_color_change_percent = 1

call minpac#add('https://github.com/godlygeek/tabular.git')
call minpac#add('https://github.com/dhruvasagar/vim-table-mode.git')

call minpac#add('https://github.com/alok/notational-fzf-vim')

let myMdNotes = expand('$MARKDOWN_NOTES')
let g:nv_search_paths = [myMdNotes]

call minpac#add('https://github.com/will133/vim-dirdiff.git')

"}}}
endif
