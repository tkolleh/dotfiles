scriptencoding utf-8
" 
" Specify python host program for vim plugins.
" Some house keeping for neovim when running on windows OS 
" 
if !exists('g:os')
    if has('win64') || has('win32') || has('win16')
        let g:on_windows_os = 1
    endif
endif

if has('nvim')
  let g:python_host_prog  = $NVIM_PY2_HOME.'/python'
  let g:python3_host_prog = $NVIM_PY3_HOME.'/python'

  if empty(glob($XDG_DATA_HOME.'/nvim/site/autoload/'))
    silent !curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endif

" Specify a directory for plugins
call plug#begin($XDG_DATA_HOME.'/nvim/plugged/')

" Make sure to use single quotes
Plug 'https://github.com/tpope/vim-dadbod.git', { 'on': ['DB']}
Plug 'https://github.com/tpope/vim-unimpaired'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/tpope/vim-obsession'
Plug 'https://github.com/tpope/vim-rhubarb.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/wellle/targets.vim.git'
Plug 'https://github.com/vim-scripts/vim-auto-save'
Plug 'skywind3000/asyncrun.vim', {'on': ['AsyncRun', 'AsyncStop'] }
Plug 'skywind3000/asynctasks.vim', {'on': ['AsyncTask', 'AsyncTaskMacro', 'AsyncTaskList', 'AsyncTaskEdit'] }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }

Plug 'francoiscabrol/ranger.vim', {'on': ['RangerCurrentFile', 'Ranger']}  
Plug 'rbgrouleff/bclose.vim' " Bclose is required for ranger installation on neovim

Plug 'https://github.com/airblade/vim-gitgutter.git'

Plug 'https://github.com/w0rp/ale.git'

Plug 'https://github.com/neovim/nvim-lspconfig.git'
Plug 'nvim-lua/diagnostic-nvim'
Plug 'nvim-lua/completion-nvim'
Plug 'https://github.com/mfussenegger/nvim-dap.git'
Plug 'https://github.com/nvim-treesitter/nvim-treesitter.git'
Plug 'https://github.com/theHamsta/nvim-dap-virtual-text.git'

"
" The following are not yet a-part of treesitter
"
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-pandoc/vim-pandoc'
Plug 'https://github.com/reasonml-editor/vim-reason-plus.git'

" Install fonts using homebrew cask room
" ref: https://github.com/ryanoasis/nerd-fonts#option-4-homebrew-fonts
"
Plug 'ryanoasis/vim-devicons'

" Cross terminal theme. See references below.
Plug 'https://github.com/lifepillar/vim-solarized8.git'

Plug 'https://github.com/vim-airline/vim-airline.git'
Plug 'https://github.com/vim-airline/vim-airline-themes.git'
Plug 'junegunn/goyo.vim', { 'for': ['markdown', 'txt', 'pandoc']}
Plug 'https://github.com/junegunn/limelight.vim.git', { 'for': ['markdown', 'txt', 'pandoc']}

if len($TMUX) > 1
  Plug 'https://github.com/christoomey/vim-tmux-navigator.git'
endif


Plug 'https://github.com/nathanaelkane/vim-indent-guides.git'
Plug 'https://github.com/godlygeek/tabular.git', { 'on': 'Tabularize'}
Plug 'https://github.com/dhruvasagar/vim-table-mode.git', { 'for': ['markdown', 'txt', 'pandoc']}
Plug 'https://github.com/alok/notational-fzf-vim'
Plug 'https://github.com/will133/vim-dirdiff.git'

" Initialize plugin system
call plug#end()

"
" Plugin specific configurations
"
"

" Diagnostic nvim configurations
let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ''
let g:diagnostic_trimmed_virtual_text = '32'
let g:diagnostic_sign_priority = 20
let g:diagnostic_enable_underline = 0
let g:space_before_virtual_text = 2
let g:diagnostic_insert_delay = 1 " Dont show diagnostics while in insert mode

" Notational fzf vim configurations
let myMdNotes = expand('$MARKDOWN_NOTES')
let g:nv_search_paths = [myMdNotes]

"
" nvim-lsp configuration
"
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>


" Pandoc prefer pdf over html default
let g:pandoc#command#prefer_pdf = 0
" Pandoc use citeproc instead of default 'fallback' for bibliography
let g:pandoc#completion#bib#mode = 'citeproc'
let g:pandoc#biblio#bibs = ['/Users/tkolleh/Documents/bibliography.bib']

" Asyncrun should open quickfix window at provided height 
let g:asyncrun_open = 7

" Async tasks project root markers
let g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', '.hg', '.idea', '.editorconfig']

" indent guides configurations
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'text', 'markdown', 'md']
let g:indent_guides_color_change_percent = 1

" editor config
" disable for vim fugitive and avoid loading for remote files 
let g:EditorConfig_exclude_patterns = ['fugitive://.\*', 'scp://.\*']
let g:EditorConfig_disable_rules = ['trim_trailing_whitespace']

" [Tags] Command to generate tags file for fzf
let g:fzf_tags_command = '!exec .git/hooks/post-merge'


" vim-auto-save
let g:auto_save = 0                 " disable AutoSave on Vim startup
let g:auto_save_silent = 0          " display the auto-save notification
let g:auto_save_no_updatetime = 1   " do not change the 'updatetime' option
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode

" vim-airline
let g:airline_powerline_fonts = 1
" let g:airline_theme='base16_vim'
let g:airline_theme='deus'
let g:webdevicons_enable_airline_statusline = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail' "options are default, jsformatter, unique_tail, and unique_tail_improved 

" Show buffer number beside tabline
let g:airline#extensions#tabline#buffer_nr_show = 1

" enable/disable vim-obsession integration
let g:airline#extensions#obsession#enabled = 1

" set marked window indicator string
let g:airline#extensions#obsession#indicator_text = ''

" Show errors and warnings in status line for ale. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1
let g:ale_enabled = 1
let g:ale_disable_lsp = 1

" Run markdown linters for pandoc"
let g:ale_linter_aliases = {'pandoc': ['markdown'], 'javascriptreact': ['javascript']}
let g:ale_set_highlights = 0

hi ALEErrorSign guifg=#dc322f guibg=NONE guisp=NONE gui=bold cterm=bold
hi ALEInfoSign guifg=#2aa198 guibg=NONE guisp=NONE gui=bold cterm=bold
hi ALEWarningSign guifg=#b58900 guibg=NONE guisp=NONE gui=bold cterm=bold

let g:ale_sign_column_always = 1
let g:ale_sign_error = ''
let g:ale_sign_warning = ''

let g:ale_echo_msg_error_str = ''
let g:ale_echo_msg_warning_str = ''
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" Ale key bindings
nmap <leader>al <Plug>(ale_lint)
nmap <leader>af <Plug>(ale_fix)

if has('nvim-0.5')
    " Work-around to deal with terminals sending ascii backspace for c-h 
    " see: https://github.com/neovim/neovim/issues/2048#issuecomment-77159983
    nmap <BS> <C-W>h

    lua require('lsp-config')
    lua require('treesitter-config')
    lua require('dap-config')

    augroup completion
      autocmd!
      " Use completion-nvim in every buffer
      autocmd BufEnter * lua require'completion'.on_attach()
    augroup end
    highlight link TSError Normal
    highlight link LspDiagnosticsError Comment
    highlight link LspDiagnosticsWarning Comment
    highlight link LspDiagnosticsInformation Comment
    highlight link LspDiagnosticsHint Comment
endif

if has('nvim-0.5')
    " nnoremap <silent> <F3> :lua require'dap'.stop()<CR>
    nnoremap <silent> <leader>dc :lua require'dap'.continue()<CR>
    " nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
    " nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
    " nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
    nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
    nnoremap <silent> <leader>B :lua require'dap'.toggle_breakpoint(vim.fn.input('Breakpoint Condition: '), nil, nil, true)<CR>
    nnoremap <silent> <leader>lp :lua require'dap'.toggle_breakpoint(nil, nil, vim.fn.input('Log point message: '), true)<CR>
    nnoremap <silent> <leader>dr :lua require'dap'.repl.toggle({height=15})<CR>
    nnoremap <silent> <leader>dl :lua require('dap').run_last()<CR>

    command -nargs=0 Into :lua require('dap').step_into()
    command -nargs=0 LspErrors :lua require('lsp-diagnostics').errors_to_quickfix()
    command -nargs=0 LspWarnings :lua require('lsp-diagnostics').warnings_to_quickfix()
    command -nargs=0 DapBreakpoints :lua require('dap').list_breakpoints()

    nnoremap <silent> <leader>q :lua require('quickfix').toggle()<CR>
endif

let g:completion_trigger_keyword_length = 3

" Use ripgrep for searching
" rg is configured to show a single result per line without color and with
" line numbers
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case --glob "\!.git"'.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)

" Ripgrep search using fzf as a simple selector interface, reloading for each
" search update.
" see: https://github.com/junegunn/fzf.vim
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Delete the selected buffer using fzf
" see: https://github.com/junegunn/fzf.vim/pull/733#issuecomment-559720813
function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

" Grepper key bindings (mapping)
nnoremap <leader>g :Grepper -tool rg<cr>
nnoremap <leader>G :Grepper -tool rg -buffers<cr>

" Enable true color support
set termguicolors

colorscheme solarized8_high    " Color scheme (cross terminal theme)
set background=light  " Set background. Must be called after setting colorscheme (cross terminal theme)

let g:solarized_diffmode = 1
let g:solarized_termtrans = 0
let g:solarized_extra_hi_groups = 0

" Enable mouse in all but command mode.
set mouse=nvirh
" Use right click as a menu, not extending selection.
set mousemodel=popup_setpos

" Height of the command bar
set cmdheight=3

" Avoid garbled characters in Chinese language windows OS
let $LANG='en_US.UTF-8' 
set langmenu=en_US.UTF-8

" Enable soft word wrap
set wrap linebreak nolist

"
" Enable sidescrolling 
" thanks to https://ddrscott.github.io/blog/2016/sidescroll/
"
set sidescroll=1
set sidescrolloff=0

if executable('par')
  set formatprg=par\ -w78
endif

set breakindent
set breakindentopt=sbr
set showbreak=↪\ 

set title
set titlestring+=\ %f


" Configure neovim to detect the type of file that is edited,
" loading the plugin files for specific file types, and loading the 
" indent file
" ** Setting is unecessary, neovim handes this **
filetype plugin indent on

if has('folding')
    set foldenable
    set foldlevel=2
    set foldlevelstart=50
    set foldcolumn=2
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
endif

" Set to auto read when a file is changed from the outside and there are no
" unsaved changes in buffer.
set autoread

" Highlight line position of cursor
set cursorline

syntax on

" Show the line and column numbers of the cursor.
set ruler
set number
set numberwidth=3

if exists('g:on_windows_os') && g:on_windows_os == 1
    set fileformats=dos,unix,mac    " Prefer Winodows
else
    set fileformats=unix,dos,mac    " Prefer Unix over Windows over OS 9 formats
endif

if !&scrolloff
  set scrolloff=3             " Show next 3 lines while scrolling.
endif

if !&sidescrolloff
  set sidescrolloff=5         " Show next 5 columns while side-scrolling.
endif

set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)

" automatically switch to case sensitive search if using capital letters else ignore case
set ignorecase
set smartcase

set showmatch                   " Do not show matching brackets by flickering
set incsearch                   " Shows the match while typing
set hlsearch                    " Highlight found searcheskk

" Use spaces instead of tabs
set tabstop=2 shiftwidth=2 expandtab

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Always display the status line, even if only one window is displayed
set laststatus=2

" Don't redraw while executing macros (good performance config)
" Set to default position (off)
set nolazyredraw 

" Update sign column every quarter second
" Default is 4000
set updatetime=250

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has('patch-8.1.1564')
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" For regular expressions turn magic on
set magic

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm


" Clear highlights of line number column
highlight clear LineNr 


"
"
" Key mappings
"
"

" use <tab> for trigger completion and navigate to the next complete item
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~ '\s'
" endfunction

" inoremap <silent><expr> <Tab>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<Tab>" :
"       \ coc#refresh()

"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"" use <cr> to confirm selection
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  else
"    call CocAction('doHover')
"  endif
"endfunction

"augroup coc_grp
"  autocmd!
"  " Setup formatexpr specified filetype(s).
"  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"  " Update signature help on jump placeholder.
"  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"augroup end

"" use `:OR` for organize import of current buffer
"command! -nargs=0 OR   :call CocAction('runCommand', 'editor.action.organizeImport')

"" Using CocList
"" Show all diagnostics
"nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
"" Manage extensions
"nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
"" Show commands
"nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
"" Find symbol of current document
"nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
"" Search workspace symbols
"nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
"" Resume latest coc list
"nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

function GoToNextError()
  " Go to next ale error
  :ALENextWrap
endfunction
noremap <silent> <space>j :call GoToNextError()<CR>

function GoToPrevError()
  " Go to previous ale error
  :ALEPreviousWrap
endfunction
noremap <silent> <space>k :call GoToPrevError()<CR>

" Use system clipboard
" set clipboard=unnamed
"
" Copy paste using system clipboard
" Copy to system clipboard
vnoremap  <leader>y  "+y
vnoremap  <leader>Y  "+yg$
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy
"
" Paste from system clipboard
"
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Jump between hunks
nmap ]g <Plug>(GitGutterNextHunk)
nmap [g <Plug>(GitGutterPrevHunk)

" Save fullpath of current buffer to unnamed clipboard
" Command reads; when pressing F4, silently save the expanded path to the
" unamed registry and do a carriage return (<CR>)
nnoremap <silent> <F4> :let @+=expand("%:p")<CR>

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search. Plus fixing syntax highlighting (sometimes Vim loses 
" highlighting due to complex highlighting rules), plus force updating the 
" syntax highlighting in diff mode
nnoremap <C-l>l :nohl<CR><C-L>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

" map jk to <ESC> when in insert mode
inoremap jk <Esc>

" quick movements
inoremap II <Esc>I
inoremap AA <Esc>A
inoremap OO <Esc>O

if len($TMUX) > 1
  " config for vim-tmux-navigator plugin
  " Do not write all buffers before navigating from Vim to tmux pane
  let g:tmux_navigator_save_on_switch = 0

  " Disable tmux navigator when zooming the Vim pane
  let g:tmux_navigator_disable_when_zoomed = 1
else
  " select window splits
  " the following key bindings are the default for the vim-tmux-navigator plugin

  echomsg 'setting window split navigation key bindings'
  nmap <C-h> <C-w>h
  nmap <C-j> <C-w>j
  nmap <C-k> <C-w>k
  nmap <C-l> <C-w>l
endif


"
" Disable ranger.vim default keybinding
"
let g:ranger_map_keys = 0
let g:ranger_replace_netrw = 0 " DO NOT open ranger when vim open a directory
let g:bclose_no_plugin_maps = 1 "Don't map to leader
map <leader>- :RangerCurrentFile<CR>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

"
" use <Tab> as trigger keys for completion-nvim
"
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ completion#trigger_completion()


"
" Open Fuzzy finder 
"
" Note: Most commands support CTRL-T / CTRL-X / CTRL-V key bindings 
" to open in a new tab, a new split, or in a new vertical split
" Bang-versions of the commands (e.g. Ag!) will open fzf in fullscreen
"
"
map <Leader>ff :Files<CR>
map <Leader>fh :History<CR>
map <Leader>fb :Buffers<CR>
map <Leader>fw :Windows<CR>
map <Leader>fl :BLines<CR>
map <Leader>fc :BCommits<CR>

" search highlighted text
vnoremap // y/\v<C-r>=escape(@",'/\')<CR><CR>

" TODO delete below after migrating to AsyncTask
" Open (preview) current file in Marked 2 
" map <Leader>mp  :AsyncRun marked '%:p'<CR>

" Use AsyncTask to build, test, run files
noremap <silent><F9>  :AsyncTask file-build<cr>
noremap <silent><F10> :AsyncTask file-run<cr>
" noremap <Leader><F9>  :CocList tasks<cr>

" Change default location of global AsyncTask file
let g:asynctasks_rtp_config = expand("$XDG_CONFIG_HOME/nvim/asynctasks.ini")


" Trim trailing whitespaces preserving cursor position
" see: http://vimcasts.org/episodes/tidying-whitespace/
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction 

function! StripTrailingWhitespaces()
    call Preserve("%s/\\s\\+$//e")
    call Preserve("normal gg=G")
endfunction

" Setup persistent undo saving to a undodir
" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand('$XDG_CONFIG_HOME/undodir')
    " Create dirs
    " This command only works in neovim as vim will through an error
    if isdirectory(myUndoDir) == 0
      call mkdir(myUndoDir, 'p')
    endif
    let &undodir = myUndoDir
    set undofile
endif

" Function to save the last vim session
let g:my_last_session = $LAST_NVIM_SESSION
function! SaveLastSession() 
    execute 'mksession! ' . g:my_last_session
endfunction

augroup save_last
    " Clear all save_last autocommands
    autocmd!    
    " Save current session to the default session file when the VimLeave event is
    " triggered
    autocmd VimLeave * call SaveLastSession()
augroup END

augroup focus_writing_grp
    " Clear all focus_writing_grp autocommands
    autocmd!    
    " Turn on LimeLight when Goyo is enabled then turn off
    " Limelight when Goyo is disabled
    autocmd User GoyoEnter Limelight
    autocmd User GoyoLeave Limelight!
augroup END

" Enable spellchecking in natural language files
augroup natural_language_files
    autocmd!
    autocmd BufRead,BufNewFile *.md,*.markdown,*mmd,*.pandoc,*.rst,*.txt setlocal spell spelllang=en_us
    autocmd FileType gitcommit setlocal spell spelllang=en_us
augroup END

augroup markdown_files
  autocmd!
  autocmd BufRead,BufNewFile *.md,*.markdown,*mmd setfiletype pandoc
augroup END
  

" Movement in Netrw (Network oriented reading writing and browsing) similiar
" to Ranger
function! NetrwBuf()
  nmap <buffer> l <CR>
endfunction

augroup NetrwFiletype
  autocmd!
  autocmd FileType netrw call NetrwBuf()
augroup END

" Only allow sourcing of unsafe commands if such files are owned by my user
set secure
