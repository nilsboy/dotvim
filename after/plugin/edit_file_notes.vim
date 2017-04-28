" Edit a file containing notes on the currently edited file.
" Usefull for filetypes that do not allow comments i.e. JSON

nnoremap <silent> <leader>gn yiW:call edit_file_notes#run(@")<cr>
vnoremap <silent> <leader>gn y:call edit_file_notes#run(@")<cr>

function! edit_file_notes#run(term)
  execute ':edit ' . expand('%:p') . '.notes.txt'
  let line_of_match = search(a:term)
  if line_of_match == 0
    normal! G
    :put =a:term . ':'
    normal! o
    :startinsert
  endif
endfunction

