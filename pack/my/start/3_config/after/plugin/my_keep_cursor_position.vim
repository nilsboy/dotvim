" Keep cursor position when switching buffers
" http://stackoverflow.com/questions/23695727/vim-highlight-a-word-with-without-moving-cursor
augroup MyKeepCursorPositionAutogroupOnSwitch
  autocmd!
  autocmd BufLeave * let b:winview = winsaveview()
  autocmd BufEnter * call my_keep_cursor_position#BuffEnter()
augroup END

function! my_keep_cursor_position#BuffEnter() abort
  " fix diff jump around due to scrollbind
  if &l:diff
    return
  endif
  if exists('b:winview')
    call winrestview(b:winview)
  endif
endfunction

" :h last-position-jump
augroup MyKeepCursorPositionAugroupOnReopen
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   execute "normal! g`\""
    \ | endif
augroup END
