augroup my_clear_cmdline#augroupClearCmdLine
  autocmd!
  autocmd InsertLeave * :echo
augroup END

finish

augroup z1_my_mappings#augroupClearCmdLine
  autocmd!
  " autocmd CursorHold * :echo
  autocmd CursorHold * :call z1_my_mappings#clearCmdLine()
augroup END

function! z1_my_mappings#clearCmdLine() abort
  if exists("z1_my_mappings#clearTimer")
    call timer_stop(z1_my_mappings#clearTimer)
  endif
  let z1_my_mappings#clearTimer = timer_start(5000, {-> execute(":echo", "")})
endfunction

