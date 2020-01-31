" TODO: add key to add entry before current or just first?
" TODO: don't jump in special buffers

" NOTE: Marks keep their position even if the underlying character moves.
" NOTE: Marks can be restored using undo and redo.
" NOTE: Do extended marks always keep their position?

let s:dir = getcwd() . '/.git'
let g:my_bufhist#file = s:dir . '/my_bufhist.json'
call mkdir(s:dir, 'p')

let s:loc = []
let s:currentIndex = -1

nnoremap <silent> <leader>se :execute 'edit ' . my_bufhist#file<cr>

nnoremap <silent> <leader>sc :call my_bufhist#clear()<cr>
function! my_bufhist#clear() abort
  let s:loc = []
  let s:currentIndex = -1
  echohl MoreMsg | echo "History cleared." | echohl None
endfunction

function! my_bufhist#index() abort
  return s:currentIndex . ' of ' . len(s:loc)
endfunction

function! my_bufhist#stillOnLastLoc() abort
  if s:currentIndex == -1
    return 0
  endif
  let lastLoc = s:loc[s:currentIndex]
  let loc = my_bufhist#getLocation()
  if loc.filename != lastLoc.filename
    return 0
  endif
  if loc.pos != lastLoc.pos
    return 0
  endif
  return 1
endfunction

nnoremap <silent> L :call my_bufhist#next()<cr>
function! my_bufhist#next() abort
  call my_bufhist#jump('next')
endfunction

nnoremap <silent> H :call my_bufhist#previous()<cr>
function! my_bufhist#previous() abort
  call my_bufhist#jump('previous')
endfunction

function! my_bufhist#jump(direction) abort
  if my_bufhist#stillOnLastLoc()
    if a:direction == 'next'
      let s:currentIndex = s:currentIndex + 1
    else
      let s:currentIndex = s:currentIndex - 1
    endif
  endif
  " call INFO('##################################### jj6')
  if len(s:loc) == 0
    let s:currentIndex = -1
    echohl MoreMsg | echo "History empty." | echohl None
    return
  endif
  if s:currentIndex <= 0
    if len(s:loc) > 0
      let s:currentIndex = 0
    else
      let s:currentIndex = -1
    endif
    echohl MoreMsg | echo "History start reached." | echohl None
  else
    if s:currentIndex >= len(s:loc) - 1
      let s:currentIndex = len(s:loc) - 1
      echohl MoreMsg | echo "History end reached." | echohl None
    endif
  endif
  let loc = s:loc[s:currentIndex]
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
  call setpos('.', s:loc[s:currentIndex].pos)
endfunction

nnoremap <silent> S :call my_bufhist#list()<cr>
function! my_bufhist#list() abort
  call setqflist(s:loc)
  call setqflist([], 'a', { 'title' : 'my_bufhist' })
  copen
endfunction

function! my_bufhist#getLocation() abort
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

nnoremap <silent> s :call my_bufhist#toggle()<cr>
function! my_bufhist#toggle() abort
  if BufferIsSpecial()
    return
  endif
  let location = my_bufhist#getLocation()
  if location.filename == ''
		echohl WarningMsg | echo "Need filename for bufhist." | echohl None
    return
  endif
  if my_bufhist#stillOnLastLoc()
    call my_bufhist#remove()
  else
    call my_bufhist#add()
  endif
endfunction

function! my_bufhist#add() abort
  let s:currentIndex = s:currentIndex + 1
  call insert(s:loc, my_bufhist#getLocation(), s:currentIndex)
endfunction

function! my_bufhist#remove() abort
  if s:currentIndex <= -1
    return
  endif
  echohl MoreMsg | echo "Removing bufhist entry." | echohl None
  let rm = remove(s:loc, s:currentIndex)
  let s:currentIndex = s:currentIndex - 1
  if s:currentIndex < -1
    let s:currentIndex = -1
  endif
endfunction

" Used for statusline
function! my_bufhist#getCurrentIndex() abort
  return s:currentIndex
endfunction

function! my_bufhist#dump() abort
  call DUMP(s:loc)
endfunction

function! my_bufhist#save() abort
  if len(s:loc) == 0
    if delete(g:my_bufhist#file) == 1
		  echohl WarningMsg | echo "Error deleting bufhist file." | echohl None
    endif
    return
  endif
  call writefile([json_encode({
    \ 'loc': s:loc, 'currentIndex': s:currentIndex
    \ })], g:my_bufhist#file)
endfunction
augroup my_bufhist#saveAutoCmd
  autocmd!
  autocmd VimLeave * :call my_bufhist#save()
augroup END

function! my_bufhist#restore() abort
  if !filereadable(g:my_bufhist#file)
    return
  endif
  let data = json_decode(readfile(g:my_bufhist#file))
  let s:loc = data.loc
  let s:currentIndex = data.currentIndex
  " call my_bufhist#jump()
endfunction
augroup my_bufhist#restoreAutoCmd
  autocmd!
  autocmd VimEnter * :call my_bufhist#restore()
augroup END 

