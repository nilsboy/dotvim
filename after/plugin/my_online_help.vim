" Note: how2 (npm) has a search count limit from google

nnoremap <silent><leader>ih yiw :silent wall \| :call MyOnlineHelp(@")<cr>
nnoremap <silent><leader>iW yiW:call MyOnlineHelp(@")<cr>
vnoremap <silent><leader>ih y:call MyOnlineHelp(@")<cr>

" TODO: allow jump to complete file
" TODO: reset search to previous value if leaving buffer?

function! MyOnlineHelp(term) abort
  let filetype = &filetype
  if filetype == ''
    let filetype = 'text'
  endif
  call Run('codesearch ', 'codesearch ' . filetype
        \ . ' ' . shellescape(a:term))
  normal! ggdd0
  let @/ = a:term
  set hlsearch
endfunction
