" no timeout
let g:tinykeymap#timeout = 0

" doh - cannot deactivate message
let g:tinykeymap#message_fmt = "%.0s%.0s"
" let g:tinykeymap#show_message = "statusline"

call tinykeymap#EnterMap('move', '<leader>b', {'name': 'move'})
call tinykeymap#Map('move', 'n', 'new') 
call tinykeymap#Map("move", "l", "bnext")
call tinykeymap#Map("move", "h", "bprev")
call tinykeymap#Map("move", "c", "bclose")
