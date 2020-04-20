finish
" Idea: create growing/shrinking top and bottom windows when start or end of file is
" reached to keep the cursor in the middle of the screen - checkout: LimitWindowSize

" nnoremap / :let b:first = 1<cr>/
" nnoremap ? :let b:first = 1<cr>?
" nnoremap n :call <SID>start()<cr>n
" nnoremap N :call <SID>start()<cr>N

" function! s:start() abort
"   if ! exists("s:signName")
"     let s:signName = get(s:, 'signName', 'SearchStart')
"     " let s:signId = get(s:, 'signId', nb#random(1000))
"     let s:signId = 2000001
"     execute 'sign define ' . s:signName . ' linehl=Todo'
"   endif
"   let b:first = get(b:, 'first', 1)
"   if b:first == 1
"     let &cursorline = 0
"     let b:startline = line('.')
"     execute 'sign unplace ' . s:signId . ' buffer=' . bufnr('%')
"     execute 'sign place ' . s:signId . ' name=' . s:signName . ' line='
"           \ . line('.') . ' buffer=' . bufnr('%')
"     let b:first = 0
"   endif
" endfunction

" augroup s:xxx
"     autocmd CursorHold * :call <sid>hlstart()
" augroup END

nnoremap <leader>y :call <sid>hlstart()<cr>

function! s:hlstart() abort
  let b:lastline = get(b:, 'lastline', line('.'))
  " call nb#info(' b:lastline: ' . b:lastline . ' line: ' . line('.'))
  if b:lastline != line('.')
    call s:hl(b:lastline)
    let b:lastline = line('.')
  endif
endfunction

sign define Lol linehl=TabLineSel
function! s:hl(...) abort
  let l:line = get(a:, '1', line('.'))
  execute 'sign unplace 2000002 buffer=' . bufnr('%')
  execute 'sign place   2000002 name=Lol line='
        \ . l:line . ' buffer=' . bufnr('%')
endfunction

" " TODO: only works when not at the beginning or end of file
" autocmd VimEnter,VimResized *
"       \ nnoremap <c-f> :execute ':normal ' . (&lines - 3) . 'j'<cr>
" autocmd VimEnter,VimResized *

" Scroll so the reading window is everything above the cursor 
" nnoremap <c-f> <c-d>kk
" nnoremap <c-b> <c-u>jj

" nnoremap <silent> <c-f> :call <sid>hl(line('$')) \| :execute ':normal ' . (&lines - 5) . 'j' \| :call <sid>hlstart()<cr>
" nnoremap <c-b> :execute ':normal ' . (&lines - 5) . 'k' \| :call <sid>hlstart()<cr>
