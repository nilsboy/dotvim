set foldenable
set foldlevel=99

" set foldmethod=marker
" set foldmarker={,}

set foldmethod=indent

" set foldnestmax=2
set fillchars+=fold:\ 
set foldexpr=
" set foldtext=
" set foldminlines=3

set foldtext=MyFoldText()
function! MyFoldText() abort
  let line = getline(v:foldstart)
  let substart = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
  let end = getline(v:foldend)
  let subend = substitute(end, '\v\s+', '', 'g')
  return substart . subend
endfunction

" set foldopen=all
" set foldclose=all

" nnoremap <expr> <CR> foldlevel('.') ? 'za' : '<CR>'
" nnoremap <CR> za

" set foldmethod=manual
" nnoremap <expr> <CR> foldlevel('.') ? 'za' : 'zfip'
" nnoremap <CR> zfip

" TODO: only search visible

finish

" Language agnostic vim plugin for folding and motion based on indentation.
PackAdd pseewald/vim-anyfold

let anyfold_activate=1
" let g:anyfold_fold_comments=1
" let g:anyfold_identify_comments
" let g:anyfold_fold_toplevel = 1
