" Keep cursor position when switching buffers.
" CursorMoved is filtered via eventignore during restores: the moved cursor
" is automatic (a view or position restore), not a manual one. This keeps
" plugins like vim-jumper from recording entry-time adjustments.
"
" (see /home/ai/src-ai/vim-jumper/PROJECT.md for why)
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
    " the cursor move is automatic (a view restore), not a manual one:
    " block CursorMoved so the vim-jumper (and any other listener that
    " distinguishes manual from scripted movements) won't see it
    set eventignore=CursorMoved,CursorMovedI
    call winrestview(b:winview)
    set eventignore&
  endif
endfunction

" :h last-position-jump
augroup MyKeepCursorPositionAugroupOnReopen
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   set eventignore=CursorMoved
    \ |   execute "normal! g`\""
    \ |   set eventignore&
    \ | endif
augroup END
