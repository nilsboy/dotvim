" Jump between recent locations
" TAGS: jumper mru
"
" - edited or viewed
" - min amount of time spent at a location makes it viable
" - need movement at a location?
" - the more recent the higher in the list
" - remove locations in files manually closed? (needs behavioural change)
" - use marks, extended marks or signs? - add later?
" - save in vim config dir / include the branch?
"
" TODO: tests - see my_jumper3.vader

" NOTE: mark jumps automatically land in locs if their location is different
" from the restored position when reopening a buffer see:
" my_keep_cursor_position.

" TODO: index out of range - check if target exists
" TODO: before jumping find current buffer in history and move it to top
" TODO: on jump check if target is current buffer and skip it
" TODO: if jump fails jump to next
" TODO: skip closed buffers?

let g:my_jumper3#locs = []
let g:my_jumper3#maxCount = 100
let g:my_jumper3#currentIndex = 0

function! my_jumper3#updateStatus() abort
  let g:my_statusline_debug = g:my_jumper3#currentIndex
    \ . ' / ' . len(g:my_jumper3#locs)
endfunction

" mode: save on cursor hold
" augroup my_jumper3#augroupJumper3
"   autocmd!
"   autocmd CursorHold * :call my_jumper3#add()
" augroup END

" mode: save if cursor moved
let g:my_jumper3#currentLoc = {}
augroup my_jumper3#augroupJumper3
  autocmd!
  " NOTE: BufEnter does not work because of my_keep_cursor_position.vim
  " NOTE: BufWinEnter when used with marks moves the cursor from line 0 to
  " the mark so those buffers will always get added
  autocmd BufWinEnter * :call my_jumper3#updateCurrentPos()
  autocmd BufLeave * :call my_jumper3#addIfPosChanged()
  autocmd CursorHold * :call my_jumper3#updateStatus()
augroup END

function! my_jumper3#updateCurrentPos() abort
  let g:my_jumper3#currentLoc = my_jumper3#getLoc()
endfunction

function! my_jumper3#addIfPosChanged() abort
  let loc = my_jumper3#getLoc()
  if g:my_jumper3#currentLoc != {}
    if loc.pos == g:my_jumper3#currentLoc.pos
      return
    endif
  endif
  call my_jumper3#add()
endfunction

let g:my_jumper3#dir = getcwd() .. '/.git'
if ! isdirectory(g:my_jumper3#dir)
  let g:my_jumper3#dir = stdpath('data') 
endif

let g:my_jumper3#file = g:my_jumper3#dir .. '/my_jumper3.json'

" function! my_jumper3#isSameLoc(loc1, loc2) abort
"   try
"     if a:loc1.filename != a:loc2.filename
"       return 0
"     endif
"     return 1
"     if a:loc1.pos != a:loc2.pos
"       return 0
"     endif
"     return 1
"   catch
"     return 0
"   endtry
" endfunction

function! my_jumper3#isSameLoc(loc1, loc2) abort
  try
    if a:loc1.filename != a:loc2.filename
      return 0
    endif
    return 1
    if a:loc1.pos != a:loc2.pos
      return 0
    endif
    return 1
  catch
    return 0
  endtry
endfunction

function! my_jumper3#removeDuplicateLoc(loc) abort
  let loc = a:loc
  let i = 0
  while i < len(g:my_jumper3#locs)
    let oldLoc = g:my_jumper3#locs[i]
    if my_jumper3#isSameLoc(oldLoc, loc)
      call remove(g:my_jumper3#locs, i)
    endif
    let i = i + 1
  endwhile
endfunction

function! my_jumper3#add() abort
  let loc = my_jumper3#getLoc()
  if loc.buftype == 'quickfix'
    return
  endif
  call my_jumper3#removeDuplicateLoc(loc)
  call nb#debug('### jj7 loc:' . json_encode(loc))
  call add(g:my_jumper3#locs, loc)
  let g:my_jumper3#currentIndex = len(g:my_jumper3#locs) - 1
endfunction

function! my_jumper3#getLoc() abort
  let loc = {}
  let [bufnr2, lnum, col, off] = getpos(".")
  let loc.pos = getpos(".")
  let loc.lnum = lnum
  let loc.col = col
  let loc.off = off
  let loc.filename = expand('%:p')
  let loc.bufnr = bufnr('%')
  let loc.text = getline(".")
  let loc.buftype = &buftype
  let loc.filetype = &filetype
  return loc
endfunction

function! my_jumper3#jump(to) abort
  if len(g:my_jumper3#locs) == 0
    return
  endif
  let to = a:to
  if to < 0
    let to = 0
  elseif to > len(g:my_jumper3#locs) - 1
    let to = len(g:my_jumper3#locs) - 1
  endif
  call nb#debug('### jj29 to: ' . to)
  let loc = g:my_jumper3#locs[to]
  let bufnr = bufnr(loc.filename)
  if bufnr != -1
    let loc.bufnr = bufnr
    silent execute 'buffer ' . bufnr
  else
    if !filereadable(loc.filename)
      call remove(g:my_jumper3#locs, g:my_jumper3#currentIndex)
      return
    endif
    silent execute 'edit ' . loc.filename
  endif
  " Succeeds even if the line does not exist anymore.
  call setpos('.', g:my_jumper3#locs[to].pos)
  let g:my_jumper3#currentIndex = to
endfunction

nnoremap <silent> L :call my_jumper3#next()<cr>
function! my_jumper3#next() abort
  call my_jumper3#addIfPosChanged() 
  call my_jumper3#jump(g:my_jumper3#currentIndex + 1)
endfunction

nnoremap <silent> H :call my_jumper3#previous()<cr>
function! my_jumper3#previous() abort
  call my_jumper3#addIfPosChanged() 
  call my_jumper3#jump(g:my_jumper3#currentIndex - 1)
endfunction

function! my_jumper3#save() abort
  if len(g:my_jumper3#locs) == 0
    if delete(g:my_jumper3#file) == 1
      call nb#debug("Error deleting jumper file.")
    endif
    return
  endif
  call mkdir(g:my_jumper3#dir, 'p')
  call writefile([json_encode({
        \ 'locs': g:my_jumper3#locs,
        \ 'currentIndex': g:my_jumper3#currentIndex
        \ })], g:my_jumper3#file)
endfunction
augroup my_jumper3#saveAutoCmd
  autocmd!
  autocmd VimLeave * :call my_jumper3#save()
augroup END

" function! my_jumper3#restore() abort
"   try
"     if !filereadable(g:my_jumper3#file)
"       return
"     endif
"     let data = json_decode(readfile(g:my_jumper3#file))
"     let g:my_jumper3#locs = data.locs
"     let g:my_jumper3#currentIndex = data.currentIndex
"   catch
"     return
"   endtry
"   " call my_jumper3#jump()
" endfunction
" augroup my_jumper3#restoreAutoCmd
"   autocmd!
"   autocmd VimEnter * :call my_jumper3#restore()
" augroup END

function! my_jumper3#qflist() abort
  let currentBufnr = bufnr('%')
              " \ 'buflisted(v:val) && (nb#buffer#isNamed(v:val) || !nb#buffer#isEmpty(v:val))'
  let list = 
    \ map(
      \ g:my_jumper3#locs,
      \ function('my_jumper3#buildEntry')
    \ )
  if len(list) == 0
    call nb#info('No jumper history.')
    return
  endif
  let i = 0
  let currentFileLine = 0
  for entry in list
    let i = i + 1
    if entry.bufnr == currentBufnr
      let currentFileLine = i
      break
    endif
  endfor
  call setqflist(list)
  " current file may not be in the listed
  if currentFileLine != 0
    execute 'silent keepjumps cc ' currentFileLine
  endif
  call setqflist([], 'a', { 'title' : 'my jumps' })
  silent! lclose
  copen
endfunction

function! my_jumper3#buildEntry(key, loc) abort
  let basename = fnamemodify(a:loc.filename, ":t")
  return {
        \ "bufnr": a:loc.bufnr,
        \ "valid": 1,
        \ "filename": a:loc.filename,
        \ "basename": basename,
        \ "text": a:loc.text,
  \ }
endfunction

function! my_jumper3#dump() abort
  call DUMP(g:my_jumper3#locs)
endfunction

nnoremap <silent> <leader>S :call my_jumper3#qflist()<cr>
nnoremap <silent> <leader>s :call my_jumper3#dump()<cr>
