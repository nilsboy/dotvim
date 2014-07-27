let g:easytags_file = TAGS
let g:easytags_on_cursorhold = 0
let g:easytags_auto_update = 0
let g:easytags_auto_highlight = 0

" If this is set and not false, it will suppress the warning on startup if
" ctags is not found or not recent enough.
let g:easytags_suppress_ctags_warning = 1

autocmd BufWritePost * exe ":UpdateTags"
