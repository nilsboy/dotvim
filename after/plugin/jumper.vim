" - only jump to changes if they are far enough away from each other
" - save one entry for files opened but not edited

" " TODO: : There are a lot more signs than marks - use them?
" TODO: 
" TODO: todo

let s:jumper_dir = $XDG_DATA_HOME . '/jumper'
let s:jumps_file = s:jumper_dir . '/jumps'

call helpers#touch(s:jumps_file)

augroup augroup_jumper
  autocmd!
  autocmd BufEnter * :call jumper#loadBufferMarks()
  autocmd BufEnter * :call jumper#add('read')
  autocmd CursorHold * :call jumper#add('read')
  autocmd InsertLeave * :call jumper#add('write')
  " For debugging
  autocmd CursorHold * :if $DEBUG | call jumper#list() | endif
augroup END

function! jumper#loadBufferMarks() abort

  if ! exists('b:jumper_marks_loaded')
    let b:jumper_marks_loaded = 0
  endif

  " Has to be done every time - vim restores them
  " if b:jumper_marks_loaded
  "   return
  " endif

  :delmarks!

  let new = jumper#getcurpos()

  for old in g:jumper_positions
    if old.filename != new.filename
      continue
    endif
    call setpos("'" . old.mark, [old.bufnum, old.lnum, old.col])
  endfor

  let b:jumper_marks_loaded = 1
  
endfunction

let s:MARKS = 'abcdefghijklmnopqrstuvwxyz'

if ! exists('g:jumper_positions')
  let g:jumper_positions = []
endif
let s:curposindex = 0

function! jumper#add(action) abort

  if BufferIsSpecial()
    return
  endif

  let new = jumper#getcurpos()
  let new.action = a:action

  call DEBUG('================== add\n'
        \ .  a:action
        \ , fnamemodify(new.filename, ':t'))

  if new.filename == ''
    return
  endif

  let new_positions = []
  let found_write_entry = 0
  for old in g:jumper_positions
    if old.filename != new.filename
      call add(new_positions, old)
      continue
    endif
    if old.action == 'read'
      if new.action == 'read' && old.lnum == new.lnum
        let found_write_entry = 1
        continue
      endif
      execute 'delmarks ' . old.mark
      continue
    endif
    let found_write_entry = 1
    if new.action == 'read'
      continue
    endif
    if old.lnum == new.lnum
      execute 'delmarks ' . old.mark
      continue
    endif
    call add(new_positions, old)
  endfor

  if new.action == 'read' && found_write_entry
    return
  endif

  let g:jumper_positions = new_positions

  let new_mark = jumper#findFreeMark()
  call setpos("'" . new_mark, getpos("'^"))
  let new.mark = new_mark

  let new.text = 'index: ' . s:curposindex
        \ . ' mark: ' . new.mark
        \ . ' action: ' . new.action
        \ . ' at: ' .  strftime("%H:%M:%S")

  call add(g:jumper_positions, new)
  let s:curposindex = len(g:jumper_positions) - 1
endfunction

function! jumper#findFreeMark() abort
  for mark_index in range(0, len(s:MARKS) - 1)
    let mark = s:MARKS[mark_index]
    let mark_pos = getpos("'". mark)
    if mark_pos == [0, 0, 0, 0]
      return mark
    endif
  endfor
  return jumper#freeAMark()
endfunction

function! jumper#freeAMark() abort
  let filename = expand('%:p')
  let index_to_remove = -1
  let pos_to_remove = {}
  for i in range(0, len(g:jumper_positions) - 1)
    let pos = g:jumper_positions[i]
    if pos.filename != filename
      continue
    endif
    let pos_to_remove = pos
    let index_to_remove = i
    break
  endfor
  " does not remove?
  let removed = remove(g:jumper_positions, index_to_remove)
  execute 'delmarks ' . pos_to_remove.mark
  return pos_to_remove.mark
  throw 'Should not happen: No free mark found'
endfunction

function! jumper#store() abort
  let lines = []
  for pos in g:jumper_positions
    call add(lines, pos.filename . ':' . pos.lnum . ':' . pos.col)
  endfor
  call writefile(lines, s:jumps_file)
endfunction

function! jumper#file() abort
    return s:jumps_file
endfunction

function! jumper#list() abort

  " Does not create a new list:
  " call setqflist(g:jumper_positions, 'r', {'title': 'Jumper list '})
  call setqflist(g:jumper_positions)
  setlocal errorformat=%f:%l:%c:

  copen

  " For debugging
  if s:curposindex == 0
    normal! gg
  else
    execute "normal! " . s:curposindex . "j"
    " execute s:curposindex . 'cc!'
  endif

  wincmd w

endfunction

function! jumper#jump(direction, movement_type) abort
  let direction = a:direction

  if len(g:jumper_positions) == 0
    call INFO('No jump history collected jet')
    return
  endif

  let movement_type = a:movement_type
  let max_index = len(g:jumper_positions) - 1
  let curpos = jumper#getcurpos()

  let pos = g:jumper_positions[s:curposindex]
  if ! jumper#isSameLine(curpos, pos)
    if jumper#jumpTo(pos)
      return
    endif
  endif

  let pos_index = s:curposindex

  let candidates = []

  while 1
    let pos_index = pos_index + direction

    if pos_index < 0 || pos_index > max_index
      break
    endif

    let pos = g:jumper_positions[pos_index]

    " Skip missing files
    if ! filereadable(pos.filename)
      continue
    endif

    if movement_type == 'file'
      if pos.filename == curpos.filename
        continue
      endif
    endif

    " if pos.filename == curpos.filename
    "   if pos.lnum > curpos.lnum - 20 && pos.lnum < curpos.lnum + 20
    "     continue
    "   endif
    " endif

    let pos.index = pos_index
    call add(candidates, pos)
  endwhile

  if ! len(candidates)
    call helpers#blinkLine()
    return
  endif

  let new_pos = candidates[0]
  
  let result = jumper#jumpTo(new_pos)
  if ! result
    call INFO('Mark does not exist anymore')
    return
  endif

  let s:curposindex = new_pos.index
endfunction

function! jumper#jumpTo(pos) abort
  let pos = a:pos
  let curpos = jumper#getcurpos()

  let bufnum = bufnr(pos.filename)
  if bufnum != -1
    execute 'buffer ' . bufnum
  else
    silent execute 'silent edit ' . pos.filename
  endif
  let bufnum = bufnr(pos.filename)

  call DEBUG('Jumping to'
        \ , 'b:' . bufnum
        \ , fnamemodify(pos.filename, ':t') . '/' . pos.lnum
        \ , '(' . pos.mark . ')')

  let mark_pos = getpos("'" . pos.mark)
  if mark_pos == [0, 0, 0, 0]
    return 0
  endif
  
  " Return code is also success if the line does not exist anymore
  call setpos('.', [bufnum, pos.lnum, pos.col])
  return 1
endfunction

function! jumper#isSameLine(pos1, pos2) abort
  let pos1 = a:pos1
  let pos2 = a:pos2
  if pos1.filename != pos2.filename
    return 0
  endif
  if pos1.lnum != pos2.lnum
    return 0
  endif
  return 1
endfunction

function! jumper#getcurpos() abort
  let pos = {}
  let [bufnum2, lnum, col, off] = getpos(".")
  let pos.lnum = lnum
  let pos.col = col
  let pos.off = off
  let pos.filename = expand('%:p')
  let pos.bufnum = bufnr('%')
  return pos
endfunction

nnoremap <silent> r <nop>
nnoremap <silent> ra :call jumper#add()<cr>
nnoremap <silent> rr :call jumper#list() \| :wincmd w<cr>
nnoremap <silent> re :execute 'silent edit ' . jumper#file()<cr>

nnoremap <silent> rn :call jumper#jump(1)<cr>
nnoremap <silent> rp :call jumper#jump(-1)<cr>

nnoremap <silent> <bs> :call jumper#jump(-1, 'change')<cr>
nnoremap <silent> <cr> :call jumper#jump(1, 'change')<cr>

" inoremap <silent> <c-u> <esc>:call jumper#jump(-1, 'change')<cr>
" inoremap <silent> <c-o> <esc>:call jumper#jump(1, 'change')<cr>

nnoremap <silent> H :call jumper#jump(-1, 'file')<cr>
nnoremap <silent> L :call jumper#jump(1, 'file')<cr>

