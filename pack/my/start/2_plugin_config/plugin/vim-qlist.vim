" Persist the results of :ilist and related commands via the quickfix list.
PackAdd romainl/vim-qlist

function! MyQlistVars() abort
  silent Verbose set include? define? includeexpr? suffixesadd?
endfunction
