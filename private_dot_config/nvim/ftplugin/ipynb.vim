echom 'Loaded jupyter notebook ftplugin file'

augroup jupyter_text_ft
  autocmd!
  autocmd BufRead,BufNewFile *.ipynb setfiletype python
augroup END
