autocmd BufReadPost * :call JavaDecompile()

function! JavaDecompile() abort
  let l:class = expand('%')
  let l:java = tempname() . '/' . expand('%:t') . '.java'
  silent execute 'edit ' . l:java
  silent execute 'r!jad -s java -lnc -p ' . l:class
  setlocal filetype=java
  normal gg
endfunction
