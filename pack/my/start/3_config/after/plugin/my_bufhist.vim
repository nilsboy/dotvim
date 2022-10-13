finish
" TODO: jump to current if last
"
" TODO: add key to add entry before current or just first?
" TODO: don't jump in special buffers

" NOTE: Marks keep their position even if the underlying character moves.
" NOTE: Marks can be restored using undo and redo.
" NOTE: Do extended marks always keep their position?

let g:my_bufhist#dir = getcwd() .. '/.git'
if ! isdirectory(g:my_bufhist#dir)
  let g:my_bufhist#dir = stdpath('data') 
endif

let g:my_bufhist#file = g:my_bufhist#dir .. '/my_bufhist.json'

function! my_bufhist#clear() abort
  let g:my_bufhist#loc = []
  " call insert(g:my_bufhist#loc, { 'filename' : '' })
  let g:my_bufhist#index = -1
endfunction
call my_bufhist#clear()

nnoremap <silent> s :call my_bufhist#toggle()<cr>
function! my_bufhist#toggle() abort
  let location = my_bufhist#loc()
  if location.filename == ''
    echohl WarningMsg | echo "Need filename for bufhist." | echohl None
    return
  endif
  if my_bufhist#isSameLoc(my_bufhist#lastLoc(), my_bufhist#loc())
    call remove(g:my_bufhist#loc, g:my_bufhist#index)
    let g:my_bufhist#index = g:my_bufhist#index - 1
  else
    let g:my_bufhist#index = g:my_bufhist#index + 1
    call insert(g:my_bufhist#loc, my_bufhist#loc(), g:my_bufhist#index)
  endif
endfunction

nnoremap <silent> <leader>se :execute 'edit ' . my_bufhist#file<cr>

nnoremap <silent> <leader>sc :call my_bufhist#clear()<cr>

function! my_bufhist#index() abort
  return g:my_bufhist#index + 1 . ' of ' . len(g:my_bufhist#loc)
endfunction

function! my_bufhist#lastLoc() abort
  try
    return g:my_bufhist#loc[g:my_bufhist#index]
  catch
    return {}
  endtry
endfunction

function! my_bufhist#isSameLoc(loc1, loc2) abort
  try
    if a:loc1.filename != a:loc2.filename
      return 0
    endif
    if a:loc1.pos != a:loc2.pos
      return 0
    endif
    return 1
  catch
    return 0
  endtry
endfunction

nnoremap <silent> L :call my_bufhist#next()<cr>
function! my_bufhist#next() abort
  call my_bufhist#jump(g:my_bufhist#index + 1)
endfunction

nnoremap <silent> H :call my_bufhist#previous()<cr>
function! my_bufhist#previous() abort
  " if ! g:my_bufhist#isSameLoc(g:my_bufhist#lastLoc(), g:my_bufhist#loc())
  "   call my_bufhist#jump(g:my_bufhist#index)
  "   return
  " endif
  call my_bufhist#jump(g:my_bufhist#index - 1)
endfunction

function! my_bufhist#jump(to) abort
  if a:to < 0 || a:to > len(g:my_bufhist#loc) - 1
    return
  endif
  let loc = g:my_bufhist#loc[a:to]
  let bufnum = bufnr(loc.filename)
  if bufnum != -1
    let loc.bufnum = bufnum
    execute 'buffer ' . bufnum
  else
    if !filereadable(loc.filename)
      call my_bufhist#remove()
      return
    endif
    silent execute 'edit ' . loc.filename
  endif
  " Succeeds even if the line does not exist anymore.
  call setpos('.', g:my_bufhist#loc[a:to].pos)
  if ! g:my_bufhist#isSameLoc(g:my_bufhist#loc(), g:my_bufhist#loc[a:to])
    call remove(g:my_bufhist#loc, a:to)
    " if g:my_bufhist#index >= a:to
    "   let g:my_bufhist#index = g:my_bufhist#index - 1
    " endif
    " call setpos('.', g:my_bufhist#loc[g:my_bufhist#index].pos)
    return
  endif
  let g:my_bufhist#index = a:to
endfunction

nnoremap <silent> S :call my_bufhist#list()<cr>
function! my_bufhist#list() abort
  call setqflist(g:my_bufhist#loc)
  call setqflist([], 'a', { 'title' : 'my_bufhist' })
  copen
endfunction

function! my_bufhist#loc() abort
  let loc = {}
  let [bufnum2, lnum, col, off] = getpos(".")
  let loc.pos = getpos(".")
  let loc.lnum = lnum
  let loc.col = col
  let loc.off = off
  let loc.filename = expand('%:p')
  let loc.bufnum = bufnr('%')
  let loc.text = getline(".")
  return loc
endfunction

function! my_bufhist#dump() abort
  call DUMP(g:my_bufhist#loc)
endfunction

function! my_bufhist#save() abort
  if len(g:my_bufhist#loc) == 0
    if delete(g:my_bufhist#file) == 1
      echohl WarningMsg | echo "Error deleting bufhist file." | echohl None
    endif
    return
  endif
  call mkdir(g:my_bufhist#dir, 'p')
  call writefile([json_encode({
        \ 'loc': g:my_bufhist#loc, 'index': g:my_bufhist#index
        \ })], g:my_bufhist#file)
endfunction
augroup my_bufhist#saveAutoCmd
  autocmd!
  autocmd VimLeave * :call my_bufhist#save()
augroup END

function! my_bufhist#restore() abort
  try
    if !filereadable(g:my_bufhist#file)
      return
    endif
    let data = json_decode(readfile(g:my_bufhist#file))
    let g:my_bufhist#loc = data.loc
    let g:my_bufhist#index = data.index
  catch
    return
  endtry
  " call my_bufhist#jump()
endfunction
augroup my_bufhist#restoreAutoCmd
  autocmd!
  autocmd VimEnter * :call my_bufhist#restore()
augroup END

