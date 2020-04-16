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
  nmap <buffer><silent> L :silent! cnewer \| :call MyStatuslineUpateQickfixValues()<cr>
  nmap <buffer><silent> H :silent! colder \| :call MyStatuslineUpateQickfixValues()<cr>
  nmap <buffer><silent> <cr> :call MyQfIsQfListError()<cr>
  nmap <buffer><silent> <leader><cr> :call MyQfIsQfListError() \| copen<cr>
  augroup MyQfAugroupBufferLeave
    autocmd!
    autocmd BufLeave <buffer> :silent! cclose
  augroup END
else
  nnoremap <silent> <c-n> :silent! keepjumps lnext<cr>
  nnoremap <silent> <c-p> :silent! keepjumps lprevious<cr>
  nmap <buffer><silent> <s-tab> :lclose<cr>
  nmap <buffer><silent> <tab> :lclose<cr>
  nmap <buffer><silent> L :silent! lnewer \| :call MyStatuslineUpateLoclistValues()<cr>
  nmap <buffer><silent> H :silent! lolder \| :call MyStatuslineUpateLoclistValues()<cr>
  nmap <buffer><silent> <cr> :call MyQfIsLocListError()<cr>
  nmap <buffer><silent> <leader><cr> :call MyQfIsLocListError() \| lopen<cr>
  " augroup MyQfAugroupBufferLeave
  "   autocmd!
  "   autocmd BufLeave <buffer> :lclose
  " augroup END
endif

set cursorline

if exists("b:MyQfFtpluginLoaded")
    finish
endif
let b:MyQfFtpluginLoaded = 1

" augroup MyQfAugroupPreview
"   autocmd!
"   autocmd! CursorMoved <buffer> nested call MyQfPreview()
" augroup END

function! MyQfPreview() abort
  let bufnr = getqflist()[getcurpos()[1]-1].bufnr
  let filename =  bufname(bufnr)
  if filename != ''
    execute 'topleft pedit ' . filename
  else
    call INFO('No valid filename on current line.')
  endif
endfunction

function! MyQfIsQfListError() abort
  if getqflist()[getcurpos()[1]-1].valid 
    execute 'keepjumps cc ' getcurpos()[1]
    " cclose
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
