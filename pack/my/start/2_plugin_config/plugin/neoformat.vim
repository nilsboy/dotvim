" A (Neo)vim plugin for formatting code.
PackAdd sbdchd/neoformat

" let g:neoformat_verbose = 1
let g:neoformat_only_msg_on_error = 1

" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1

nnoremap <silent> <leader>x :Neoformat<cr>

" function! AutoCmdNeoFormat() abort
"   let foo = 'neoformat#formatters#' . &filetype . '#'
"   if !exists('neoformat#formatters#' . &filetype . '#')
"     echo "No formatter found for filetype: " . foo
"     return
"   endif
"   Neoformat
" endfunction

nnoremap <silent> <leader>X :let b:MyNeoformatAutoFormatEnabled = 1<cr>
augroup MyNeoformatAugroupFormat
  autocmd!
  " CursorHoldI does not work in combination with ale or nvim-completion-manager
  autocmd CursorHold * call MyNeoformatFormat()
augroup END

function! MyNeoformatFormat() abort
  if ! exists('b:MyNeoformatAutoFormatEnabled')
    return
  endif
  if ! exists('b:MyNeoformatChangeTick')
    let b:MyNeoformatChangeTick = 0
  endif
  " if b:MyNeoformatChangeTick == 0
  "   " avoid running when opening new buffer
  if b:MyNeoformatChangeTick != b:changedtick
    Neoformat
  endif
  let b:MyNeoformatChangeTick = b:changedtick
endfunction
