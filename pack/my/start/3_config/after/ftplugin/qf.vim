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
  nnoremap <silent> <buffer> <c-n> :silent! keepjumps cnext \| copen<cr>
  nnoremap <silent> <buffer> <c-p> :silent! keepjumps cprevious \| copen<cr>
  nnoremap <buffer><silent> <tab> :cclose<cr>
  nnoremap <buffer><silent> L :silent! cnewer \| :call MyStatuslineUpateQickfixValues()<cr>
  nnoremap <buffer><silent> H :silent! colder \| :call MyStatuslineUpateQickfixValues()<cr>
  nnoremap <buffer><silent> <cr> :call MyQfIsQfListError()<cr>
  nnoremap <buffer><silent> <leader><cr> :call MyQfIsQfListError() \| copen<cr>
  augroup MyQfAugroupBufferLeave
    autocmd!
    autocmd BufLeave <buffer> :silent! cclose
  augroup END
else
  nnoremap <silent> <c-n> :silent! keepjumps lnext \| lopen<cr>
  nnoremap <silent> <c-p> :silent! keepjumps lprevious \| lopen<cr>
  nnoremap <silent> <buffer> <c-n> :silent! keepjumps lnext<cr>
  nnoremap <silent> <buffer> <c-p> :silent! keepjumps lprevious<cr>
  nnoremap <buffer><silent> <s-tab> :lclose<cr>
  nnoremap <buffer><silent> <tab> :lclose<cr>
  nnoremap <buffer><silent> L :silent! lnewer \| :call MyStatuslineUpateLoclistValues()<cr>
  nnoremap <buffer><silent> H :silent! lolder \| :call MyStatuslineUpateLoclistValues()<cr>
  nnoremap <buffer><silent> <cr> :call MyQfIsLocListError()<cr>
  nnoremap <buffer><silent> <leader><cr> :call MyQfIsLocListError() \| lopen<cr>
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
    call nb#info('No valid filename on current line.')
  endif
endfunction

function! MyQfIsQfListError() abort
  if getqflist()[getcurpos()[1]-1].valid 
    execute 'keepjumps cc ' getcurpos()[1]
    " cclose
  else
    call nb#info('No valid error on current line.')
  endif
endfunction

function! MyQfIsLocListError() abort
  if getloclist(0)[getcurpos()[1]-1].valid
    execute 'keepjumps ll ' . getcurpos()[1]
    lclose
  else
    call nb#info('No valid error on current line.')
  endif
endfunction
