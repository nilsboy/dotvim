function! nb#buffer#isNamed(bufnr) abort
  if empty(bufname(a:bufnr))
    return 0
  endif
  return 1
endfunction

function! nb#buffer#isEmpty(bufnr) abort
  if getbufline(a:bufnr, 1, "$") == ['']
    return 1
  else
    return 0
  endif
endfunction

" Close a buffer writing its content and closing vim if appropriate.
function! nb#buffer#close() abort

  " only close preview-window if open and return
  silent! wincmd P
  if &previewwindow
    silent! pclose
    return
  endif

  if len(win_findbuf(bufnr('%'))) > 1
    quit
    return
  endif

  if BufferIsCommandLine() == 1
    silent! quit
    return
  elseif BufferIsQuickfix()
    cclose
    return
  elseif BufferIsLoclist()
    lclose
    return
  elseif BufferIsNetrw() == 1
    " Netrw leaves its buffers in a weired state
    silent! bwipeout!
    return
  endif

  let wasQfOpen = MyHelpersQuickfixIsOpen()
  if wasQfOpen
    cclose
    return
  endif

  let wasLlOpen = MyHelpersLoclistIsOpen()
  if wasLlOpen
    lclose
    return
  endif

  lclose

  if nb#buffer#isNamed('%')
    if &write
      update
    endif
  else
    if !nb#buffer#isEmpty('%')
      call nb#warn('Buffer has no name.')
      return
    endif
  endif

  if nb#buffer#isLast()
    if !nb#buffer#isNamed('%')
      call nb#info('Last buffer.')
      return
    else
      keepjumps new | only
      silent! keepjumps edit #
      execute 'lcd ' . g:start_cwd
    endif
    " silent! q!
  endif

  " use bdelete instead of bwipeout to not loose marks
  silent! bdelete!

  if wasQfOpen
    copen
    wincmd p
  endif

  if wasLlOpen
    lopen
    wincmd p
  endif

  set nocursorline
endfunction

function! nb#buffer#isSpecial() abort
  if &previewwindow == 1
    return 1
  endif
  return bufname('%') =~ '\v.*\[.*' ? 1 : 0
endfunction

function! nb#buffer#isLast() abort
  let lastBuffer = bufnr('$')
  let listed = 0
  let i = 1
  while i <= lastBuffer
    if buflisted(i) == 1
      let listed = listed + 1
    endif
    if listed > 1
      return 0
    endif
    let i = i + 1
  endwhile
  return 1
endfunction

function! nb#buffer#findByFiletype() abort
  let lastBuffer = bufnr('$')
  let listed = 0
  let i = 1
  while i <= lastBuffer
    if buflisted(i) == 1
      let listed = listed + 1
    endif
    if listed > 1
      return 0
    endif
    let i = i + 1
  endwhile
  return 1
endfunction

function! nb#buffer#findByName(name) abort
  let lastBuffer = bufnr('$')
  let i = 1
  while i <= lastBuffer
    if bufname(i) =~ fnameescape(a:name)
      return i
    endif
    let i = i + 1
  endwhile
  return 0
endfunction

