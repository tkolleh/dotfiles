" 
" Specify python host program for vim plugins.
" Some house keeping for neovim when running on windows OS 
" 
if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:on_windows_os = 1
    endif
endif

let g:python_host_prog = $NVIM_PY2_HOME."/python"
let g:python3_host_prog = $NVIM_PY3_HOME."/python"

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Symlink created for neovim to ~/.vimrc
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin($XDG_DATA_HOME."/plugged/")

" Make sure to use single quotes

Plug 'https://tpope.io/vim/unimpaired.git'
Plug 'https://github.com/wellle/targets.vim.git'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/vim-scripts/vim-auto-save'
Plug 'https://github.com/pseewald/vim-anyfold.git'
Plug 'https://github.com/skywind3000/asyncrun.vim.git'

Plug 'https://github.com/w0rp/ale.git'
" Packages installed for use with ale
" - https://github.com/amperser/proselint
" - https://github.com/get-alex/alex
" - https://github.com/mads-hartmann/bash-language-server
" - https://prettier.io/docs/en/install.html
" - https://github.com/rhysd/fixjson
" - http://www.html-tidy.org/
" - https://eslint.org/docs/user-guide/command-line-interface

Plug 'https://github.com/tpope/vim-surround.git'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'https://github.com/aklt/plantuml-syntax'
Plug 'https://github.com/scrooloose/nerdtree.git'

" Requires the installation of universal ctags
" `brew install --HEAD universal-ctags/universal-ctags/universal-ctags`
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'

Plug 'https://github.com/lifepillar/vim-solarized8.git'
Plug 'https://github.com/vim-airline/vim-airline.git'
Plug 'https://github.com/vim-airline/vim-airline-themes.git'
Plug 'junegunn/goyo.vim'
Plug 'https://github.com/junegunn/limelight.vim.git'

" Initialize plugin system
call plug#end()

" Plugin specific configurations
let g:gutentags_modules = ['ctags', 'gtags_cscope'] " enable gtags module
let g:gutentags_project_root = ['.root'] " config project root markers.
let g:gutentags_cache_dir = expand('~/.cache/tags') " generate datebases in my cache directory, prevent gtags files polluting my project
let g:gutentags_plus_switch = 1 " change focus to quickfix window after search (optional).
" let g:gutentags_trace = 1 " enable trace logging

" vim-auto-save
let g:auto_save = 0                 " disable AutoSave on Vim startup
let g:auto_save_silent = 0          " display the auto-save notification
let g:auto_save_no_updatetime = 1   " do not change the 'updatetime' option
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = '|'
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail' "options are default, jsformatter, unique_tail, and unique_tail_improved 
let g:airline_theme='papercolor'
" Show buffer number beside tabline
let g:airline#extensions#tabline#buffer_nr_show = 1

" Enable completion where available.
" This setting must be set before ALE is loaded.
let g:ale_completion_enabled = 1

" Use ripgrep for searching
" rg is configured to show a single result per line without color and with
" line numbers
if executable('rg')
    " Use rg over grep
    set grepprg=rg\ --vimgrep
endif

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Inable true color support
set termguicolors

colorscheme solarized8_high    " Color scheme 
set background=light           " Set background. Must be called after setting colorscheme 

" Height of the command bar
set cmdheight=3

" Avoid garbled characters in Chinese language windows OS
let $LANG='en' 
set langmenu=en

" Enable soft word wrap
set wrap linebreak nolist

" Configure Vim to load plugins 
filetype plugin on

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

syntax on

" Show the line and column numbers of the cursor.
set ruler
set number
set numberwidth=3
set encoding=utf-8              " Set default encoding to UTF-8

if exists("g:on_windows_os") && g:on_windows_os == 1
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

" Always display the status line, even if only one window is displayed
set laststatus=2

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" For regular expressions turn magic on
set magic

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm


"
" Key mappings
"
" Use system clipboard
" set clipboard=unnamed

" Save fullpath of current buffer to unnamed clipboard
" Command reads; when pressing F4, silently save the expanded path to the
" unamed registry and do a carriage return (<CR>)
nnoremap <silent> <F4> :let @+=expand("%:p")<CR>

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-l>l :nohl<CR><C-L>

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

" open Fuzzy finder 
map <C-f>f :Files<CR>
map <C-b>b :Buffers<CR>

" search highlighted text
vnoremap // y/<C-R>"<CR>

" Setup persistent undo saving to a undodir
" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand($XDG_CONFIG_HOME . '/undodir')
    " Create dirs
    " This command only works in neovim as vim with through an error
    call mkdir(myUndoDir, 'p')
    let &undodir = myUndoDir
    set undofile
endif

" Function to save the last vim session
let g:my_last_session = $LAST_NVIM_SESSION
function! SaveLastSession() 
    execute 'tabdo NERDTreeClose'
    execute 'mksession! ' . g:my_last_session
endfunction

augroup vimrc
    " Remove all vimrc autocommands
    autocmd!    
    " Turn on LimeLight when Goyo is enabled then turn off
    " Limelight when Goyo is disabled
    autocmd! User GoyoEnter Limelight
    autocmd! User GoyoLeave Limelight!
    " Save current session to the default session file when the VimLeave event is
    " triggered
    autocmd VimLeave * call SaveLastSession() 
    " NERDTree
    " Open NERDTree when vim starts up on opening a directory. This is tab
    " specific
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
    " Fix known bug When editing a remote file using :e scp://user@host/file,
    " netrw sets buftype=nofile which causes error E382 to be raised when trying
    " to write changes. According to :h buftype, instead of using bt=nofile, netrw
    " should use bt=acwrite 
    autocmd BufRead scp://* :set bt=acwrite
    " activate for all filetypes
    autocmd Filetype * AnyFoldActivate               
augroup END
