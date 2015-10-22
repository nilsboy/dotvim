"### Keep cursor position on undo and redo #####################################

map <silent> u :call MyUndo()<CR>
function! MyUndo()
    let _view=winsaveview()
    :undo
    call winrestview(_view)
endfunction

map <silent> <c-r> :call MyRedo()<CR>
function! MyRedo()
    let _view=winsaveview()
    :redo
    call winrestview(_view)
endfunction

"###############################################################################
