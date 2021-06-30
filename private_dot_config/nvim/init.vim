scriptencoding utf-8

if !exists('g:os')
    if has('win64') || has('win32') || has('win16')
        let g:on_windows_os = 1
        set fileformats=dos,unix,mac
    else
        let g:on_windows_os = 0
        set fileformats=unix,dos,mac
    endif
endif

if has('nvim')
  let g:python_host_prog  = $NVIM_PY2_HOME.'/python'
  let g:python3_host_prog = $NVIM_PY3_HOME.'/python'

  if !empty(glob($XDG_CONFIG_HOME.'/nvim/options.vim'))
      if !empty(glob($XDG_CONFIG_HOME.'/nvim/packages.vim'))
        source $XDG_CONFIG_HOME/nvim/packages.vim
        source $XDG_CONFIG_HOME/nvim/options.vim
      endif
  endif
else
    set pyxversion=3

    " OSX
    set pythonthreedll=/Library/Frameworks/Python.framework/Versions/3.6/Python

    " Windows
    set pythonthreedll=python37.dll
    set pythonthreehome=C:\Python37
endif

" Enable true color support
set termguicolors

packadd! github-colors

" set background=dark
set background=light
colorscheme github-colors

highlight FoldColumn guibg=white guifg=darkgrey

let mapleader='\'
let maplocalleader='_'

set mouse=nvirh
set mousemodel=popup_setpos
set cmdheight=3

" Avoid garbled characters in Chinese language windows OS
let $LANG='en_US.UTF-8' 
set langmenu=en_US.UTF-8

set wrap linebreak nolist

set breakindent
set breakindentopt=sbr
set showbreak=↪\ 

set title
set titlestring+=\ %f

if has('folding')
    set foldenable
    set foldlevel=2
    set foldlevelstart=50
    set foldcolumn=2
endif

if executable('par')
  set formatprg=par\ -w78
else
  echoerr 'Unable to find par executable for formatprg'
endif

set autoread
set cursorline

set ruler
set number
set numberwidth=3

if !&scrolloff
  set scrolloff=3             " Show next 3 lines while scrolling.
endif

set sidescroll=1
set sidescrolloff=0
if !&sidescrolloff
  set sidescrolloff=5         " Show next 5 columns while side-scrolling.
endif

set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
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
"
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
set updatetime=250

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has('patch-8.1.1564')
  set signcolumn=number
else
  set signcolumn=yes
endif

" For regular expressions turn magic on
set magic

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

syntax on

" Clear highlights of line number column
highlight clear LineNr 

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


" Save fullpath of current buffer to unnamed clipboard Command reads; when pressing F4, silently save the expanded path to the unamed registry and do a carriage return (<CR>)
"
nnoremap <silent> <F4> :let @+=expand("%:p")<CR>

" Map <C-L> (redraw screen) to also turn off search highlighting until
" the next search. Plus fixing syntax highlighting (sometimes Vim loses
" highlighting due to complex highlighting rules), plus force updating the syntax highlighting in diff mode
"
nnoremap <C-l>l :nohl<CR><C-L>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

" map jk to <ESC> when in insert mode
inoremap jk <Esc>

" quick movements
inoremap II <Esc>I
inoremap AA <Esc>A
inoremap OO <Esc>O

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" search highlighted text
vnoremap // y/\v<C-r>=escape(@",'/\')<CR><CR>

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
    let myUndoDir = expand('$XDG_CONFIG_HOME/nvim/undodir')
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


" Enable spellchecking in natural language files
augroup natural_language_files
    autocmd!
    autocmd BufRead,BufNewFile *.md,*.markdown,*mmd,*.pandoc,*.rst,*.txt setlocal spell spelllang=en_us
    autocmd FileType gitcommit setlocal spell spelllang=en_us
augroup END

" Movement in Netrw (Network oriented reading writing and browsing) similiar to Ranger
"
function! NetrwBuf()
  nmap <buffer> l <CR>
endfunction

augroup NetrwFiletype
  autocmd!
  autocmd FileType netrw call NetrwBuf()
augroup END

set secure
