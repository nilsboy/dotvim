set autoread
set autowriteall

" FocusGained / FocusLost do not get triggert in TUI without workaround
augroup my_auto_save_and_load#augroup
  autocmd!
  autocmd VimSuspend,FocusLost,BufLeave,WinLeave,QuickFixCmdPre,CursorHold * silent! wall
  autocmd VimResume,FocusGained,BufEnter,WinEnter,CursorHold,QuickFixCmdPost * silent! checktime
  autocmd CursorMoved * silent! checktime %
augroup end
