" Jump between recent locations
" TAGS: jumper mru
"
" TODO: when jumping back don't change history until jump is over?
" TODO: when jumping back don't change history until cursor moved to diff loc?
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

let g:my_jumper3#locs = []
let g:my_jumper3#maxCount = 100
let g:my_jumper3#currentIndex = 0

augroup my_jumper3#augroupJumper3
  autocmd!
  autocmd CursorHold * :call my_jumper3#add()
augroup END

let g:my_jumper3#dir = getcwd() .. '/.git'
if ! isdirectory(g:my_jumper3#dir)
  let g:my_jumper3#dir = stdpath('data') 
endif

let g:my_jumper3#file = g:my_jumper3#dir .. '/my_jumper3.json'

call nb#debug('### jj192 g:my_jumper3#file: ' . g:my_jumper3#file)

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
  call add(g:my_jumper3#locs, loc)
  let g:my_jumper3#currentIndex= len(g:my_jumper3#locs) - 1
endfunction

function! my_jumper3#getLoc() abort
  let loc = {}
  let [bufnum2, lnum, col, off] = getpos(".")
  let loc.pos = getpos(".")
  let loc.lnum = lnum
  let loc.col = col
  let loc.off = off
  let loc.filename = expand('%:p')
  let loc.bufnum = bufnr('%')
  let loc.text = getline(".")
  let loc.buftype = &buftype
  let loc.filetype = &filetype
  return loc
endfunction

function! my_jumper3#jump(to) abort
  call nb#debug('### jj75 to: ' . a:to . '/' . len(g:my_jumper3#locs))
  if a:to < 0 || a:to > len(g:my_jumper3#locs) - 1
    return
  endif
  let loc = g:my_jumper3#locs[a:to]
  let bufnum = bufnr(loc.filename)
  if bufnum != -1
    let loc.bufnum = bufnum
    execute 'buffer ' . bufnum
  else
    if !filereadable(loc.filename)
      call nb#debug('### jj59 removing loc:' . json_encode(loc))
      call remove(g:my_jumper3#locs, g:my_jumper3#currentIndex)
      return
    endif
    silent execute 'edit ' . loc.filename
  endif
  " Succeeds even if the line does not exist anymore.
  call setpos('.', g:my_jumper3#locs[a:to].pos)
  let g:my_jumper3#currentIndex = a:to
  call nb#debug('##################################### jj69 jumped')
endfunction

nnoremap <silent> L :call my_jumper3#next()<cr>
function! my_jumper3#next() abort
  call my_jumper3#jump(g:my_jumper3#currentIndex + 1)
endfunction

nnoremap <silent> H :call my_jumper3#previous()<cr>
function! my_jumper3#previous() abort
  call my_jumper3#jump(g:my_jumper3#currentIndex - 1)
endfunction

nnoremap <silent> <leader>S :call my_jumper3#dump()<cr>
function! my_jumper3#dump() abort
  call DUMP(g:my_jumper3#locs)
endfunction

function! my_jumper3#save() abort
  if len(g:my_jumper3#locs) == 0
    if delete(g:my_jumper3#file) == 1
      call nb#info("Error deleting jumper file.")
    endif
    return
  endif
  call nb#debug('### jj194 g:my_jumper3#file: ' . g:my_jumper3#file)
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
