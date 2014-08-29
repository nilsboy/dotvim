" no timeout
let g:tinykeymap#timeout = 0

" doh - cannot deactivate message
let g:tinykeymap#message_fmt = "%.0s%.0s"
" let g:tinykeymap#show_message = "statusline"

call tinykeymap#EnterMap('buffer-move', '<leader>b', {'name': 'buffer-move'})
call tinykeymap#Map('buffer-move', 'n', 'new') 
call tinykeymap#Map("buffer-move", "c", "bdelete")
call tinykeymap#Map("buffer-move", "l", "bnext")
call tinykeymap#Map("buffer-move", "h", "bprev")

call tinykeymap#EnterMap('window-move', '<leader>ww', {'name': 'window-move'})
call tinykeymap#Map('window-move', 'n', 'new') 
call tinykeymap#Map("window-move", "c", "close")
call tinykeymap#Map("window-move", "h", "wincmd h")
call tinykeymap#Map("window-move", "l", "wincmd l")
call tinykeymap#Map("window-move", "j", "wincmd j")
call tinykeymap#Map("window-move", "k", "wincmd k")

call tinykeymap#EnterMap('mytags', '<leader>t', {'name': 'mytags'})
call tinykeymap#Map("mytags", "t", ':UniteWithCursorWord -buffer-name=unite-tags -keep-focus tag')
" call tinykeymap#Map("mytags", "t", ':new | :UniteWithCursorWord -buffer-name=unite-tags -keep-focus tag')
" call tinykeymap#Map("mytags", "t", 'tjump <C-w>')
call tinykeymap#Map("mytags", "T", "tjump")
call tinykeymap#Map("mytags", "l", "tnext")
call tinykeymap#Map("mytags", "j", "tprev")
" nnoremap <silent>t :execute 'tjump ' . expand("<cword>")<cr>
" nnoremap <silent>T :tjump 

call tinykeymap#EnterMap('mymarks', '<leader>m', {'name': 'mymarks'})
" jump to next lowercase mark
call tinykeymap#Map("mymarks", "k", "normal ['")
" jump to previous lowercase mark 
call tinykeymap#Map("mymarks", "j", "normal ]'")

" Don't load default keymaps
let g:tinykeymaps_default = [""]
