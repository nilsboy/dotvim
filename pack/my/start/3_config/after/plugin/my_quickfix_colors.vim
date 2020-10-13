sign define ErrorMsg text=! texthl=ErrorMsg linehl=ErrorMsg
sign define WarningMsg text=w texthl=WarningMsg linehl=WarningMsg
sign define MoreMsg text=i texthl=MoreMsg linehl=MoreMsg

augroup MyQfAugroupHilight
  autocmd!
  " TODO: only when qf buffer is loaded
  autocmd BufWinEnter * call MyQuickfixColorsColor()
augroup END

function! MyQuickfixColorsColor() abort
  let qfBufferNumber = GetQuickfixBufferNumber()
  if !qfBufferNumber
    return
  endif
  execute 'sign unplace * buffer=' . qfBufferNumber
  if BufferIsLoclist()
    let qflist = getloclist(0)
  else
    let qflist = getqflist()
  endif
  let signId = 8000
  for entry in qflist
    let signId = signId + 1
    if !entry.valid
      continue
    endif
    if entry.type == 'i'
      let signName = 'MoreMsg'
    elseif entry.type == 'w'
      let signName = 'WarningMsg'
    elseif entry.type == 'e'
      let signName = 'ErrorMsg'
    else
      continue
    endif
    execute 'sign place ' . signId 
      \ . ' line=' . (signId - 8000)
      \ . ' name=' . signName . ' buffer=' . qfBufferNumber
  endfor
endfunction
