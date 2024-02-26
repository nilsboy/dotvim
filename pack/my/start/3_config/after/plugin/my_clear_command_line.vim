augroup my_clear_command_line#augroupClear
  autocmd!
  autocmd BufLeave,InsertLeave * echo
augroup END

finish

augroup my_clear_command_line#augroupClearCmdLine
  autocmd!
  " autocmd CursorHold * :echo
  autocmd CursorHold * :call z1_my_mappings#clearCmdLine()
augroup END

function! my_clear_command_line#clearCmdLine() abort
  if exists("z1_my_mappings#clearTimer")
    call timer_stop(z1_my_mappings#clearTimer)
  endif
  let z1_my_mappings#clearTimer = timer_start(5000, {-> execute(":echo", "")})
endfunction
