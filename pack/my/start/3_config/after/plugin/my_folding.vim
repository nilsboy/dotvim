set nofoldenable | finish
set foldenable

" set foldlevel=99

" set foldmethod=marker
" set foldmarker={,}

" set foldmethod=indent
set foldmethod=syntax

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

