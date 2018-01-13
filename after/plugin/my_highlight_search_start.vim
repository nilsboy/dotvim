finish
" TODO: play nice with previous nN-mappings
nnoremap / :let b:first = 1<cr>/
nnoremap ? :let b:first = 1<cr>?
nnoremap n :call <SID>start()<cr>n
nnoremap N :call <SID>start()<cr>N

function! s:start() abort
  if ! exists("s:signName")
    let s:signName = get(s:, 'signName', 'SearchStart')
    " let s:signId = get(s:, 'signId', helpers#random(1000))
    let s:signId = 2000001
    execute 'sign define ' . s:signName . ' linehl=Todo'
  endif
  let b:first = get(b:, 'first', 1)
  if b:first == 1
    let &cursorline = 0
    let b:startline = line('.')
    execute 'sign unplace ' . s:signId . ' buffer=' . bufnr('%')
    execute 'sign place ' . s:signId . ' name=' . s:signName . ' line='
          \ . line('.') . ' buffer=' . bufnr('%')
    let b:first = 0
  endif
endfunction

augroup highlight_search_start_CursorMoved
    autocmd CursorMoved * :call <sid>hlstart()
augroup END

function! s:hlstart() abort
  let b:cursorline = get(b:, 'cursorline', &cursorline)
  let b:startline = get(b:, 'startline', 0)
  if b:startline == line('.')
    let &cursorline = 0
  else
    let &cursorline = b:cursorline
    " unlet b:cursorline
  endif
endfunction

