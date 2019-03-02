finish
" The ultimate undo history visualizer for VIM
" NOTE: diff view is confusing
PackAdd mbbill/undotree

let g:undotree_HighlightChangedText = 1
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_DiffAutoOpen = 0
let g:undotree_CustomUndotreeCmd  = 'botright new'
