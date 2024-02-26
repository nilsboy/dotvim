" Yoink will automatically maintain a history of yanks that you can choose between when pasting.
" TAGS: history clipboard copy paste

set shada+=!
" Prefer xsel over xclip to avoid "Clipboard error : Target STRING not available"
" https://github.com/svermeulen/vim-yoink/issues/16#issuecomment-632234373
let g:clipboard = {
  \   'name': 'xsel_override',
  \   'copy': {
  \      '+': 'xsel --input --clipboard',
  \      '*': 'xsel --input --primary',
  \    },
  \   'paste': {
  \      '+': 'xsel --output --clipboard',
  \      '*': 'xsel --output --primary',
  \   },
  \   'cache_enabled': 1,
  \ }

let g:yoinkIncludeDeleteOperations = 1
let g:yoinkSavePersistently = 1
let g:yoinkMaxItems = 100

PackAdd svermeulen/vim-yoink

nmap y <plug>(YoinkYankPreserveCursorPosition)
xmap y <plug>(YoinkYankPreserveCursorPosition)

nnoremap <silent> <leader>p :call vim_yoink#list()<cr>
function! vim_yoink#list() abort
  let list = 
    \ map(
    \ yoink#getYankHistory(),
      \ function('vim_yoink#keyEntry')
    \ )
  call setqflist(list)
  call setqflist([], 'a', { 
    \ 'title' : 'copy history', 'context': { 'qftype': 'vim_yoink#qfType' } })
  silent! lclose
  copen
endfunction

function! vim_yoink#keyEntry(key, yoink) abort
  return {
    \ "bufnr": 0,
    \ "valid": 1,
    \ "filename": '',
    \ "text": a:yoink.text,
  \ }
endfunction

function! vim_yoink#qfType() abort
  nnoremap <buffer><silent> <cr> :call vim_yoink#copyQfEntry('e')<cr>
  nnoremap <buffer><silent> p :call vim_yoink#copyQfEntry('p')<cr>
  nnoremap <buffer><silent> P :call vim_yoink#copyQfEntry('P')<cr>
  nnoremap <buffer><silent><nowait> y :call vim_yoink#copyQfEntry('y')<cr>
  nnoremap <buffer><silent> c :call vim_yoink#clear()<cr>
endfunction

function! vim_yoink#clear() abort
  cclose
  silent ClearYanks
  call vim_yoink#list()
  copen
endfunction

function! vim_yoink#copyQfEntry(key) abort
  let newPaste = getqflist()[getcurpos()[1]-1].text
  call setreg('+', newPaste)
  execute 'cc ' getcurpos()[1]
  cclose
  if a:key ==# 'y'
    " nothing
  elseif a:key ==# 'p'
    normal! p
  elseif a:key ==# 'P'
    normal! P
  elseif a:key ==# 'e'
    silent normal! p
    copen
  endif
endfunction
