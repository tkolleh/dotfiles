" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

syntax on

" Map leader key to spacebar
nnoremap <SPACE> <Nop>
let mapleader = " "

" Avoid garbled characters in Chinese language windows OS
let $LANG='en' 
set langmenu=en

" Enable soft word wrap
set wrap linebreak nolist

" Configure Vim to load plugins 
filetype plugin on

" vim-auto-save
let g:auto_save = 0                 " disable AutoSave on Vim startup
let g:auto_save_silent = 0          " display the auto-save notification
let g:auto_save_no_updatetime = 1   " do not change the 'updatetime' option
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent on
set foldlevelstart=50

" Display possible folds in a foldcolumn
set foldcolumn=2

" Set to auto read when a file is changed from the outside and there are no
" unsaved changes in buffer.
set autoread

" Show the line and column numbers of the cursor.
set ruler
set number
set numberwidth=3
set encoding=utf-8              " Set default encoding to UTF-8

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
set tabstop=4 shiftwidth=4 expandtab

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" For regular expressions turn magic on
set magic

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

"
" Key mappings
"

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
" nnoremap <C-l>l :nohl<CR><C-L>"
nnoremap <leader>h :nohl<CR><C-L>

" map jk to <ESC> when in insert mode
inoremap jk <Esc>

" quick movements
inoremap II <Esc>I
inoremap AA <Esc>A
inoremap OO <Esc>O

" select windows
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" search highlighted text
vnoremap // y/<C-R>"<CR>

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
