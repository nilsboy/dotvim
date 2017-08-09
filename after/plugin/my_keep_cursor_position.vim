" Keep cursor position when switching buffers
" http://stackoverflow.com/questions/23695727/vim-highlight-a-word-with-without-moving-cursor
augroup MyKeepCursorPositionAutogroup
  autocmd!
  autocmd BufLeave * let b:winview = winsaveview()
  autocmd BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
augroup END

" Keep cursor position when reopening a file
autocmd BufReadPost * if line("'\"") | exe "normal '\"" | endif