setlocal nowrap

" nmap <buffer><silent> f :QFilter<space>

execute &cmdwinheight . 'wincmd _'

nnoremap <silent> <buffer> <bs> :call MyQuickfixFormatToggle()<cr>

nmap <buffer> <c-u> <esc><c-u>
nmap <buffer> <c-o> <esc><c-o>

nmap <buffer> <leader>x :set modifiable \| :keepjumps %s/\\%u00/\\r/g<cr>

if BufferIsQuickfix()
  nnoremap <silent> <c-n> :silent! keepjumps cnext \| call MySetErrorMarkers()<cr>
  nnoremap <silent> <c-p> :silent! keepjumps cprevious \| call MySetErrorMarkers()<cr>
  nmap <buffer><silent> <tab> :cclose<cr>
  nmap <buffer><silent> L :silent! cnewer<cr>
  nmap <buffer><silent> H :silent! colder<cr>
  nmap <buffer><silent> <cr> :call MyQfIsQfListError()<cr>
  augroup MyQfAugroupBufferLeave
    autocmd!
    autocmd BufLeave <buffer> :silent! cclose
  augroup END
else
  nnoremap <silent> <c-n> :silent! keepjumps lnext \| call MySetErrorMarkers()<cr>
  nnoremap <silent> <c-p> :silent! keepjumps lprevious \| call MySetErrorMarkers()<cr>
  nmap <buffer><silent> <s-tab> :lclose<cr>
  nmap <buffer><silent> <tab> :lclose<cr>
  nmap <buffer><silent> L :silent! lnewer<cr>
  nmap <buffer><silent> H :silent! lolder<cr>
  nmap <buffer><silent> <cr> :call MyQfIsLocListError()<cr>
  " produces E924 when pressing the above <cr>-mapping - unlike with quickfix
  " list.
  " augroup MyQfAugroupBufferLeave
  "   autocmd!
  "   autocmd BufLeave <buffer> :silent! lclose
  " augroup END
endif

" RemoveErrorMarkers 
" call MySetErrorMarkers()

set cursorline

if exists("b:MyQfFtpluginLoaded")
    finish
endif
let b:MyQfFtpluginLoaded = 1

function! MyQfIsQfListError() abort
  if getqflist()[getcurpos()[1]-1].valid 
    execute 'keepjumps cc ' getcurpos()[1]
    cclose
  else
    call INFO('No valid error on current line.')
  endif
endfunction

function! MyQfIsLocListError() abort
  if getloclist(0)[getcurpos()[1]-1].valid
    execute 'll ' . getcurpos()[1]
    lclose
  else
    call INFO('No valid error on current line.')
  endif
endfunction
