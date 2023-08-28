finish
" An experiment in jumping
"
" - only jump to changes if they are far enough away from each other
" - save only one entry for files opened but not edited

" TODO: There are a lot more signs than marks - use them instead?
" TODO: remove escaped buffers from alternate buffer or remove from jump list?

let g:MyJumperDir = stdpath("data") . '/jumper'
let g:MyJumperFile = g:MyJumperDir . '/jumps'

call nb#touch(g:MyJumperFile)

augroup MyJumperAugroup
  autocmd!
  autocmd BufEnter * :call MyJumperLoadBufferMarks()
  autocmd BufEnter * :call MyJumperAdd('read')
  autocmd CursorHold * :call MyJumperAdd('read')
  autocmd InsertLeave * :call MyJumperAdd('write')
  " For debugging
  autocmd CursorHold * :if $DEBUG | call MyJumperList() | endif
augroup END

function! MyJumperLoadBufferMarks() abort
  if ! exists('b:jumper_marks_loaded')
    let b:jumper_marks_loaded = 0
  endif

  " Has to be done every time - vim restores them
  " if b:jumper_marks_loaded
  "   return
  " endif

  delmarks!

  let new = MyJumperGetcurpos()

  for old in g:jumper_positions
    if old.filename != new.filename
      continue
    endif
    call setpos("'" . old.mark, [old.bufnum, old.lnum, old.col])
  endfor

  let b:jumper_marks_loaded = 1
  
endfunction

let g:MyJumperMarks = 'bcdefghijklmnopqrstuvwxyz'

if ! exists('g:jumper_positions')
  let g:jumper_positions = []
endif
let g:MyJumperCurposIndex = 0

function! MyJumperAdd(action) abort

  if nb#buffer#isSpecial()
    return
  endif

  let new = MyJumperGetcurpos()
  let new.action = a:action

  call nb#debug('================== add\n'
        \ .  a:action
        \ . fnamemodify(new.filename, ':t'))

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

  let new_mark = MyJumperFindFreeMark()
  call setpos("'" . new_mark, getpos("'^"))
  let new.mark = new_mark

  let new.text = 'index: ' . g:MyJumperCurposIndex
        \ . ' mark: ' . new.mark
        \ . ' action: ' . new.action
        \ . ' at: ' .  strftime("%H:%M:%S")

  call add(g:jumper_positions, new)
  let g:MyJumperCurposIndex = len(g:jumper_positions) - 1
endfunction

function! MyJumperFindFreeMark() abort
  for mark_index in range(0, len(g:MyJumperMarks) - 1)
    let mark = g:MyJumperMarks[mark_index]
    let mark_pos = getpos("'". mark)
    if mark_pos == [0, 0, 0, 0]
      return mark
    endif
  endfor
  return MyJumperFreeAMark()
endfunction

function! MyJumperFreeAMark() abort
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

function! MyJumperStore() abort
  let lines = []
  for pos in g:jumper_positions
    call add(lines, pos.filename . ':' . pos.lnum . ':' . pos.col)
  endfor
  call writefile(lines, g:MyJumperFile)
endfunction

function! MyJumperFile() abort
    return g:MyJumperFile
endfunction

function! MyJumperList() abort

  " Does not create a new list:
  " call setqflist(g:jumper_positions, 'r', {'title': 'Jumper list '})
  call setqflist(g:jumper_positions)
  setlocal errorformat=%f:%l:%c:

  copen

  " For debugging
  if g:MyJumperCurposIndex == 0
    normal! gg
  else
    execute "normal! " . g:MyJumperCurposIndex . "j"
    " execute g:MyJumperCurposIndex . 'cc!'
  endif

  wincmd w

endfunction

function! MyJumperJump(direction, movement_type) abort
  let direction = a:direction

  if len(g:jumper_positions) == 0
    call nb#info('No jump history collected jet')
    return
  endif

  let movement_type = a:movement_type
  let max_index = len(g:jumper_positions) - 1
  let curpos = MyJumperGetcurpos()

  let pos = g:jumper_positions[g:MyJumperCurposIndex]
  if ! MyJumperIsSameLine(curpos, pos)
    if MyJumperJumpTo(pos)
      return
    endif
  endif

  let pos_index = g:MyJumperCurposIndex

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
    call nb#blinkLine()
    return
  endif

  let new_pos = candidates[0]
  
  let result = MyJumperJumpTo(new_pos)
  if ! result
    call nb#info('Mark does not exist anymore')
    return
  endif

  let g:MyJumperCurposIndex = new_pos.index
endfunction

function! MyJumperJumpTo(pos) abort
  let pos = a:pos
  let curpos = MyJumperGetcurpos()

  let bufnum = bufnr(pos.filename)
  if bufnum != -1
    execute 'buffer ' . bufnum
  else
    silent execute 'silent edit ' . pos.filename
  endif
  let bufnum = bufnr(pos.filename)

  call nb#debug('Jumping to'
        \ . 'b:' . bufnum
        \ . fnamemodify(pos.filename, ':t') . '/' . pos.lnum
        \ . '(' . pos.mark . ')')

  let mark_pos = getpos("'" . pos.mark)
  if mark_pos == [0, 0, 0, 0]
    return 0
  endif
  
  " Return code is also success if the line does not exist anymore
  call setpos('.', [bufnum, pos.lnum, pos.col])
  return 1
endfunction

function! MyJumperIsSameLine(pos1, pos2) abort
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

function! MyJumperGetcurpos() abort
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
nnoremap <silent> ra :call MyJumperAdd()<cr>
nnoremap <silent> rr :call MyJumperList() \| :wincmd w<cr>
nnoremap <silent> re :execute 'silent edit ' . MyJumperFile()<cr>

nnoremap <silent> rn :call MyJumperJump(1)<cr>
nnoremap <silent> rp :call MyJumperJump(-1)<cr>

nnoremap <silent> <bs> :call MyJumperJump(-1, 'change')<cr>
nnoremap <silent> <cr> :call MyJumperJump(1, 'change')<cr>

" inoremap <silent> <c-u> <esc>:call MyJumperJump(-1, 'change')<cr>
" inoremap <silent> <c-o> <esc>:call MyJumperJump(1, 'change')<cr>

" nnoremap <silent> H :call MyJumperJump(-1, 'file')<cr>
" nnoremap <silent> L :call MyJumperJump(1, 'file')<cr>

