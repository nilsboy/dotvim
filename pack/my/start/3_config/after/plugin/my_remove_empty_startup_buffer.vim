" Remove the empty startup buffer left over when the buffer list is restored
" from the shada file ('%' flag, see persist_to_wd.vim).
"
" Neovim always starts with a listed empty buffer.  Restoring the buffer
" list from shada only adds the previously used buffers - it never displays
" one and never removes the startup buffer.  Result: an empty [No Name]
" buffer next to the restored buffers.
"
" Here: switch to a restored buffer and wipe the empty one.  Nothing is
" done when the current buffer is not the empty startup buffer (e.g. when
" vim was started with a file argument which reused the startup buffer).
"
" NOTE: startup order in nvim main.c is:
"   source_startup_scripts -> load_plugins (incl. after/plugin sourcing)
"   -> shada_read_everything -> create_windows -> VimEnter
" so this autocmd fires WITH the restored buffer list, not before it.
"
" DEBUG: reasons are written to g:nb#logfile (see it with <leader>vm).

" VimEnter handlers of other plugins may switch to another buffer while the
" empty buffer 1 stays listed.  Retry once via timer: covers buffers
" switched away during startup, too.  All checks are idempotent.
let s:removedEmptyStartupBuffer = 0

function! s:IsEmptyStartupBuffer(nr) abort
  return bufname(a:nr) ==# ''
        \ && getbufvar(a:nr, '&buftype') ==# ''
        \ && !getbufvar(a:nr, '&modified')
        \ && getbufline(a:nr, 1, '$') ==# ['']
endfunction

" nb#debug only writes to the log file.  With
" g:my_remove_empty_startup_buffer_debug reasons are shown with :messages too.
function! s:Log(msg) abort
  call nb#debug('my_remove_empty_startup_buffer: ' . a:msg)
  if get(g:, 'my_remove_empty_startup_buffer_debug')
    echom 'my_remove_empty_startup_buffer: ' . a:msg
  endif
endfunction

" Run manually at any time, e.g. for testing in a running instance
" (VimEnter does not fire again there).
command! -bar MyRemoveEmptyStartupBuffer call s:RemoveEmptyStartupBuffer()

function! s:ListedBuffersForLog() abort
  let listed = []
  for n in range(1, bufnr('$'))
    if buflisted(n)
      call add(listed, n . ':' . bufname(n))
    endif
  endfor
  return string(listed)
endfunction

function! s:UnusedEmptyStartupBuffers() abort
  let unused = []
  for n in range(1, bufnr('$'))
    if s:IsEmptyStartupBuffer(n) && empty(win_findbuf(n))
      call add(unused, n)
    endif
  endfor
  return unused
endfunction

function! s:RemoveEmptyStartupBuffer() abort
  call s:Log('enter: bufname=' . string(bufname('%'))
        \ . ' buftype=' . string(&buftype) . ' modified=' . &modified
        \ . ' listed=' . s:ListedBuffersForLog())
  if bufname('%') !=# ''
    call s:Log('skip: current buffer is named: ' . bufname('%'))
  else
    if ! s:IsEmptyStartupBuffer(bufnr('%'))
      call s:Log('skip: current buffer is not empty')
      return
    endif

    " First named listed buffer to display instead.
    let target = 0
    for n in range(1, bufnr('$'))
      if n != bufnr('%') && buflisted(n) && bufname(n) !=# ''
        let target = n
        break
      endif
    endfor

    if target != 0
      let empty = bufnr('%')
      " silent!: continue on E32 when the file no longer exists.
      silent! execute 'buffer' target
      if bufnr('%') != target
        call s:Log('failed to switch to buffer ' . target)
        return
      endif
      execute 'silent bwipeout' empty
      let s:removedEmptyStartupBuffer = 1
      call s:Log('switched to buffer ' . target
            \ . '(' . bufname(target) . '), wiped ' . empty)
    else
      call s:Log('skip: no named listed buffer')
    endif
  endif

  " Wipe empty buffers not displayed anywhere (e.g. buffer 1 when another
  " VimEnter handler already switched to a named buffer).
  if ! s:removedEmptyStartupBuffer
    for n in s:UnusedEmptyStartupBuffers()
      call s:Log('wipe unused empty buffer ' . n)
      execute 'silent bwipeout' n
    endfor
    let s:removedEmptyStartupBuffer = 1
  endif
endfunction

function! s:RemoveEmptyStartupBufferLater(timer) abort
  call s:RemoveEmptyStartupBuffer()
endfunction

augroup my_remove_empty_startup_buffer
  autocmd!
  autocmd VimEnter * call timer_start(0, function('s:RemoveEmptyStartupBufferLater'))
augroup END
