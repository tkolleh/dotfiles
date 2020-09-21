" Check pandoc files.
let b:ale_linters = ['lint-md', 'alex', 'proselint', 'languagetool']

" Fix pandoc files
let b:ale_fixers = ['prettier']

" Disable warnings about trailing whitespace for Python files.
let b:ale_warn_about_trailing_whitespace = 0
