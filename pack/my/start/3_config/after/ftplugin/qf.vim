execute 'setlocal ' . g:MyQuickfixWrap

execute &cmdwinheight . 'wincmd _'

nnoremap <silent> <buffer> <bs> :call MyQuickfixFormatToggle()<cr>

nmap <buffer> <c-u> <esc><c-u>
nmap <buffer> <c-o> <esc><c-o>

nmap <buffer> <leader>x :set modifiable \| :keepjumps %s/\\%u00/\\r/g<cr>

if BufferIsQuickfix()
  let g:my_quickfix#currentList = 'quickfix'
  nnoremap <silent> <c-n> :silent! keepjumps cnext<cr>
  nnoremap <silent> <c-p> :silent! keepjumps cprevious<cr>
  nnoremap <silent> <buffer> <c-n> :silent! keepjumps cnext \| copen<cr>
  nnoremap <silent> <buffer> <c-p> :silent! keepjumps cprevious \| copen<cr>
  nnoremap <buffer><silent> <tab> :cclose<cr>
  nnoremap <buffer><silent> L :silent! cnewer \| :call MyStatuslineUpateQickfixValues()<cr>
  nnoremap <buffer><silent> H :silent! colder \| :call MyStatuslineUpateQickfixValues()<cr>
  nnoremap <buffer><silent> <cr> :call MyQfIsQfListError()<cr>
  nnoremap <buffer><silent> <leader><cr> :silent call MyQfIsQfListError() \| copen<cr>
  nnoremap <buffer> x :call qf#closeBuffer()<cr> 
  augroup MyQfAugroupBufferLeave
    autocmd!
    autocmd BufLeave <buffer> :silent! cclose
  augroup END
else
  let g:my_quickfix#currentList = 'loclist'
  nnoremap <silent> <c-n> :silent! keepjumps lnext<cr>
  nnoremap <silent> <c-p> :silent! keepjumps lprevious<cr>
  nnoremap <silent> <buffer> <c-n> :silent! keepjumps lnext \| lopen<cr>
  nnoremap <silent> <buffer> <c-p> :silent! keepjumps lprevious \| lopen<cr>
  nnoremap <buffer><silent> <s-tab> :lclose<cr>
  nnoremap <buffer><silent> <tab> :lclose<cr>
  nnoremap <buffer><silent> L :silent! lnewer \| :call MyStatuslineUpateLoclistValues()<cr>
  nnoremap <buffer><silent> H :silent! lolder \| :call MyStatuslineUpateLoclistValues()<cr>
  nnoremap <buffer><silent> <cr> :call MyQfIsLocListError()<cr>
  nnoremap <buffer><silent> <leader><cr> :silent call MyQfIsLocListError() \| lopen<cr>
  " augroup MyQfAugroupBufferLeave
  "   autocmd!
  "   autocmd BufLeave <buffer> :silent! lclose
  " augroup END
endif

augroup qf#augroupResetErrors
  autocmd!
  autocmd QuickFixCmdPost <buffer> :let g:MyStatuslineQfErrors = '' 
  " autocmd QuickFixCmdPostBufLeave <buffer> :let g:MyStatuslineQfErrors = '' 
augroup END

set cursorline

if exists("b:MyQfFtpluginLoaded")
    finish
endif
let b:MyQfFtpluginLoaded = 1

function! qf#closeBuffer() abort
  let saved_cursor = getcurpos()
  let bufnr = getqflist()[getcurpos()[1]-1].bufnr
  execute 'bd ' . bufnr
  call qf#RemoveEntry(getcurpos()[1]-1)
  call MyQuickfixFormat()
  call setpos('.', saved_cursor)
endfunction

function! qf#RemoveEntry(lnum) abort
  let qflist = getqflist()
  let newQflist = []
  let i = -1
  for entry in qflist
    let i = i + 1
    if i != a:lnum
      call add(newQflist, entry)
    endif
  endfor
  call setqflist(newQflist, 'r')
endfunction

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
    call nb#warn('No valid filename on current line.')
  endif
endfunction

function! MyQfIsQfListError() abort
  if getqflist()[getcurpos()[1]-1].valid 
    execute 'cc ' getcurpos()[1]
    " cclose
  else
    call nb#warn('No valid error on current line.')
  endif
endfunction

function! MyQfIsLocListError() abort
  if getloclist(0)[getcurpos()[1]-1].valid
    execute 'll ' . getcurpos()[1]
    lclose
  else
    call nb#warn('No valid error on current line.')
  endif
endfunction
