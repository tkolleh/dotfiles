scriptencoding utf-8

packadd! vim-auto-save

  let g:auto_save = 0                 " disable AutoSave on Vim startup
  let g:auto_save_silent = 0          " display the auto-save notification
  let g:auto_save_no_updatetime = 1   " do not change the 'updatetime' option
  let g:auto_save_in_insert_mode = 0  " do not save while in insert mode

packadd! asyncrun.vim
  packadd! asynctasks.vim

  let g:asyncrun_open = 7
  let g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', '.hg', '.idea', '.editorconfig']

  noremap <silent><F9>  :AsyncTask file-build<cr>
  noremap <silent><F10> :AsyncTask file-run<cr>

  " Change default location of global AsyncTask file
  let g:asynctasks_rtp_config = expand("asynctasks.ini")

packadd! fzf
  packadd! fzf.vim

  " [Tags] Command to generate tags file for fzf
  let g:fzf_tags_command = '!exec .git/hooks/post-merge'

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

  "
  " Open Fuzzy finder 
  "
  " Note: Most commands support CTRL-T / CTRL-X / CTRL-V key bindings 
  " to open in a new tab, a new split, or in a new vertical split
  " Bang-versions of the commands (e.g. Ag!) will open fzf in fullscreen
  "
  map <leader>ff :Files<CR>
  map <leader>fh :History<CR>
  map <leader>fb :Buffers<CR>
  map <leader>fw :Windows<CR>
  map <leader>fl :BLines<CR>
  map <leader>fc :BCommits<CR>

packadd! vim-grepper
  command! -nargs=+ -complete=file Rgb Grepper -noprompt -buffers -tool rg -query <args>

packadd! ranger.vim
  packadd! bclose.vim
  "
  " Disable ranger.vim default keybinding
  "
  let g:ranger_map_keys = 0
  let g:ranger_replace_netrw = 0 " DO NOT open ranger when vim open a directory
  let g:bclose_no_plugin_maps = 1 "Don't map to leader
  map <leader>- :RangerCurrentFile<CR>

packadd! vim-gitgutter
  nmap ]g <Plug>(GitGutterNextHunk)
  nmap [g <Plug>(GitGutterPrevHunk)


if has('nvim-0.5')
  " packadd! commands are apart of the import statements
  lua require('treesitter-config')
  lua require('lsp-config')
  lua require('dap-config')

  nnoremap <silent> gi    <cmd>lua vim.lsp.buf.declaration()<CR>
  nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent> <c-i> <cmd>lua vim.lsp.buf.signature_help()<CR>
  nnoremap <silent> gy    <cmd>lua vim.lsp.buf.type_definition()<CR>
  nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
  nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

  highlight link TSError Normal

  command -nargs=0 LspErrors :lua require('lsp-diagnostics').errors_to_quickfix()
  command -nargs=0 LspWarnings :lua require('lsp-diagnostics').warnings_to_quickfix()

  noremap <silent> <space>j :NextDiagnosticCycle<CR>
  noremap <silent> <space>k :PrevDiagnosticCycle<CR>

  if has('folding')
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
  endif

  packadd! completion-buffers

  augroup completion
    autocmd!
    " Use completion-nvim in every buffer
    autocmd BufEnter * lua require'completion'.on_attach()
  augroup end

 "
 " use <Tab> and <S-Tab> as trigger keys for completion menue
 "
 function! s:check_back_space() abort
     let col = col('.') - 1
     return !col || getline('.')[col - 1]  =~ '\s'
 endfunction

 inoremap <silent><expr> <TAB>
   \ pumvisible() ? "\<C-n>" :
   \ <SID>check_back_space() ? "\<TAB>" :
   \ completion#trigger_completion()

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
  command -nargs=0 DapBreakpoints :lua require('dap').list_breakpoints()

  packadd! ultisnips
    packadd! vim-snippets

    " Trigger configuration. Change to something else than <tab> if using
    " completion-nvim
    let g:UltiSnipsExpandTrigger="<c-n>"
    let g:UltiSnipsJumpForwardTrigger="<c-b>"
    let g:UltiSnipsJumpBackwardTrigger="<c-z>"

    " If you want :UltiSnipsEdit to split your window.
    let g:UltiSnipsEditSplit="vertical"

else
  packadd vim-polyglot
endif

packadd! vim-pandoc
packadd! vim-pandoc-syntax

  augroup markdown_files
    autocmd!
    autocmd BufRead,BufNewFile *.md,*.markdown,*mmd setfiletype pandoc
  augroup END

  " Pandoc prefer pdf over html default
  " Pandoc use citeproc instead of default 'fallback' for bibliography
  let g:pandoc#command#prefer_pdf = 0
  let g:pandoc#completion#bib#mode = 'citeproc'

packadd! jupytext.vim

let g:jupytext_fmt = 'py'
let g:jupytext_filetype_map = {'md': 'pandoc'}

packadd! editorconfig-vim
  " editor config
  " disable for vim fugitive and avoid loading for remote files 
  let g:EditorConfig_exclude_patterns = ['fugitive://.\*', 'scp://.\*']
  let g:EditorConfig_disable_rules = ['trim_trailing_whitespace']

packadd! goyo.vim
packadd! limelight.vim
  augroup focus_writing_grp
      " Clear all focus_writing_grp autocommands
      autocmd!    
      " Turn on LimeLight when Goyo is enabled then turn off
      " Limelight when Goyo is disabled
      autocmd User GoyoEnter Limelight
      autocmd User GoyoLeave Limelight!
  augroup END

if len($TMUX) > 1
  packadd! vim-tmux-navigator
  " config for vim-tmux-navigator plugin
  " Do not write all buffers before navigating from Vim to tmux pane
  let g:tmux_navigator_save_on_switch = 0

  " Disable tmux navigator when zooming the Vim pane
  let g:tmux_navigator_disable_when_zoomed = 1
else
  nmap <C-h> <C-w>h
  nmap <C-j> <C-w>j
  nmap <C-k> <C-w>k
  nmap <C-l> <C-w>l
endif

packadd! vim-indent-guides
  " indent guides configurations
  let g:indent_guides_start_level = 2
  let g:indent_guides_guide_size = 1
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'text', 'markdown', 'md']
  let g:indent_guides_color_change_percent = 1

packadd! notational-fzf-vim
  let myMdNotes = expand('$MARKDOWN_NOTES')
  let g:nv_search_paths = [myMdNotes]

packadd! vim-devicons
packadd! vim-airline
  packadd! vim-airline-themes

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

" TODO: check if jupyter is available on the path then add plugin
" packadd! jupyter-vim
  let g:jupyter_mapkeys = 1
  " Run current file
  nnoremap <buffer> <silent> <leader>jR :JupyterRunFile<CR>
  nnoremap <buffer> <silent> <leader>jI :PythonImportThisFile<CR>

  " Change to directory of current file
  nnoremap <buffer> <silent> <leader>jd :JupyterCd %:p:h<CR>

  " Send a selection of lines
  nnoremap <buffer> <silent> <leader>jX :JupyterSendCell<CR>
  nnoremap <buffer> <silent> <leader>jE :JupyterSendRange<CR>
  nmap     <buffer> <silent> <leader>je <Plug>JupyterRunTextObj
  vmap     <buffer> <silent> <leader>je <Plug>JupyterRunVisual

  nnoremap <buffer> <silent> <leader>jU :JupyterUpdateShell<CR>

  " Debugging maps
  nnoremap <buffer> <silent> <leader>jb :PythonSetBreak<CR>

packadd! vim-dadbod
packadd! vim-unimpaired
packadd! vim-commentary
packadd! vim-fugitive
packadd! vim-obsession
packadd! vim-rhubarb
packadd! vim-surround
packadd! targets.vim
packadd! neoformat
packadd! editorconfig-vim
packadd! tabular
packadd! vim-dirdiff
packadd! vim-reason-plus
