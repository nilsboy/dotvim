function! JavaClassDecompile() abort
  let l:class = expand('%')
  let l:classBufferNo = bufnr('%')
  let l:java = tempname() . '/' . expand('%:t') . '.java'
  silent execute 'edit ' . l:java
  silent execute 'r!jad -s java -lnc -p ' . l:class
  setlocal filetype=java
  execute 'bdelete ' . l:classBufferNo
endfunction

call JavaClassDecompile()
