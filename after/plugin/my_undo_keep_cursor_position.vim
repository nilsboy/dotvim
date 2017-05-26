" Keep cursor position on undo and redo
finish " #######################################################################

function! MyUndoKeepCursorPositionUndo()
    let _view=winsaveview()
    undo
    call winrestview(_view)
endfunction
map <silent> u :call MyUndoKeepCursorPositionUndo()<CR>

function! MyUndoKeepCursorPositionRedo()
    let _view=winsaveview()
    redo
    call winrestview(_view)
endfunction
map <silent> <c-r> :call MyUndoKeepCursorPositionRedo()<CR>
