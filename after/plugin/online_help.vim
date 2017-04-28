" Note: how2 (npm) has a search count limit from google

nnoremap <silent><leader>ih yiw :silent wall \| :call online_help#help(@")<cr>
nnoremap <silent><leader>iW yiW:call online_help#help(@")<cr>
vnoremap <silent><leader>ih y:call online_help#help(@")<cr>

" TODO: allow jump to complete file
" TODO: reset search to previous value if leaving buffer?

function! online_help#help(term) abort
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
