finish

" A marks experiment.
"
" Features:
" Update file marks when leaving their buffer.
" Split home row in local marks and file marks all lower case.
"
" NOTE: Lowercase marks 'a to 'z are remembered as long as the file remains in the
" buffer list.

augroup MyUpdateMarksAugroup
  autocmd!
  autocmd BufLeave :call MyUpdateMarks()
augroup END

function! MyUpdateMarks() abort

endfunction
