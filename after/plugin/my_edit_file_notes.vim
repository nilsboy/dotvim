finish
" Edit a file containing notes on the currently edited file.
" Usefull for filetypes that do not allow comments i.e. JSON
" SEE ALSO: https://github.com/fourjay/vim-quaff

nnoremap <silent> <leader>gn yiW:call MyEditFileNotes(@")<cr>
vnoremap <silent> <leader>gn y:call MyEditFileNotes(@")<cr>

function! MyEditFileNotes(term)
  execute ':edit ' . expand('%:p') . '.notes.txt'
  let line_of_match = search(a:term)
  if line_of_match == 0
    normal! G
    :put =a:term . ':'
    normal! o
    :startinsert
  endif
endfunction

