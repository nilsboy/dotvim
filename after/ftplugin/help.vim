" These options only seem to work for the :help command
" but not for the k-mapping
setlocal buflisted
only

setlocal keywordprg=:help

augroup augroup_help
  autocmd!
  autocmd BufLeave <buffer> normal! mH
augroup END

