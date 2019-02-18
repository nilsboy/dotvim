setlocal nowrap

" nmap <buffer><silent> f :QFilter<space>

execute &cmdwinheight . 'wincmd _'

nnoremap <silent> <buffer> <bs> :call MyQuickfixFormatToggle()<cr>

nmap <buffer> <c-u> <esc><c-u>
nmap <buffer> <c-o> <esc><c-o>

nmap <buffer> <leader>x :set modifiable \| :keepjumps %s/\\%u00/\\r/g<cr>

if BufferIsQuickfix()
  nnoremap <silent> <c-n> :silent! keepjumps cnext<cr>
  nnoremap <silent> <c-p> :silent! keepjumps cprevious<cr>
  nmap <buffer><silent> <tab> :cclose<cr>
  nmap <buffer><silent> L :silent! cnewer<cr>
  nmap <buffer><silent> H :silent! colder<cr>
  nmap <buffer><silent> <cr> :call MyQfIsQfListError()<cr>
  augroup MyQfAugroupBufferLeave
    autocmd!
    autocmd BufLeave <buffer> :cclose
  augroup END
else
  nnoremap <silent> <c-n> :silent! keepjumps lnext<cr>
  nnoremap <silent> <c-p> :silent! keepjumps lprevious<cr>
  nmap <buffer><silent> <s-tab> :lclose<cr>
  nmap <buffer><silent> <tab> :lclose<cr>
  nmap <buffer><silent> L :silent! lnewer<cr>
  nmap <buffer><silent> H :silent! lolder<cr>
  nmap <buffer><silent> <cr> :call MyQfIsLocListError()<cr>
  augroup MyQfAugroupBufferLeave
    autocmd!
    autocmd BufLeave <buffer> :lclose
  augroup END
endif

if exists("b:MyQfFtpluginLoaded")
    finish
endif
let b:MyQfFtpluginLoaded = 1

function! MyQfIsQfListError() abort
  if getqflist()[getcurpos()[1]-1].valid 
    keepjumps .cc
    cclose
  else
    call INFO('No valid error on current line.')
  endif
endfunction

function! MyQfIsLocListError() abort
  if getqflist()[getcurpos()[1]-1].valid 
    .cc
    cclose
  else
    call INFO('No valid error on current line.')
  endif
endfunction

