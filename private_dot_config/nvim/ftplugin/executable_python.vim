echom 'Loaded python (ftplugin)'

" Check Python files with flake8 and pylint.
" let b:ale_linters = {'python': ['flake8', 'pylint', 'mypy']}
let b:ale_linters = {'python': ['flake8', 'pylint']}

" Fix Python files with autopep8 and yapf.
let b:ale_fixers = {'python': ['black', 'autopep8', 'yapf']}

" Disable warnings about trailing whitespace for Python files.
let b:ale_warn_about_trailing_whitespace = 0
let b:ale_fix_on_save = 1
