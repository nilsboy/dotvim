finish
" A marks experiment.
"
" Features:
" Update file marks when leaving their buffer.
" Split home row in local marks and file marks all lower case.
"
" NOTE: Lowercase marks 'a to 'z are remembered as long as the file remains in the
" buffer list.

" Marks:
" switch lower case marks with uppercase ones
" https://www.reddit.com/r/vim/comments/3g5v2m/is_there_any_way_to_use_lowercase_marks_instead/ctv5k6s/
" noremap <silent> <expr> ' "`".toupper(nr2char(getchar()))
" noremap <silent> <expr> m "m".toupper(nr2char(getchar()))
" sunmap '
" sunmap m

augroup MyUpdateMarksAugroup
  autocmd!
  autocmd BufLeave * call MyUpdateMarks()
augroup END

function! MyUpdateMarks() abort
  wshada! ~/tmp/jo.shada
endfunction
