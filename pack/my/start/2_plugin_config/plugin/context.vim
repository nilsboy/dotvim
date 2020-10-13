let g:context_enabled = 0
let g:context_add_mappings = 0
" let g:context_add_autocmds = 0

let g:context_max_join_parts = 100
" let g:context_max_per_indent = 1
let g:context_ellipsis_char = ''

" let g:context_resize_linewise = 1
" let g:context_max_height = 1

let g:context_presenter = 'preview'

" shows the context of the currently visible buffer contents
PackAdd wellle/context.vim

nnoremap <silent> <leader>jc :ContextToggle<cr>

" TODO: test: change autocmds to only update on cursor hold?
