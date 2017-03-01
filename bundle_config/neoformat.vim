" A (Neo)vim plugin for formatting code.
NeoBundle 'sbdchd/neoformat'

" TODO: use formatprg?: https://github.com/sbdchd/neoformat/issues/36

" let g:neoformat_verbose = 1
let g:neoformat_only_msg_on_error = 1

" " Enable alignment
" let g:neoformat_basic_format_align = 1

" " Enable tab to spaces conversion
" let g:neoformat_basic_format_retab = 1

" " Enable trimmming of trailing whitespace
" let g:neoformat_basic_format_trim = 1

" augroup ConfigNeoformat
"   autocmd!
"   autocmd TextChanged * Neoformat
" augroup END
"
" autocmd InsertLeave * :Neoformat eslint \| :Neoformat eswraplines<cr>

nnoremap <leader>x :Neoformat<cr>

finish

function! AutoCmdNeoFormat() abort
  let ha = 'neoformat#formatters#' . &filetype . '#'
  if !exists('neoformat#formatters#' . &filetype . '#')
    echo "No formatter found for filetype: " . ha
    return
  endif
  Neoformat
endfunction
