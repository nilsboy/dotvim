finish
" Saves yank history includes unite.vim history/yank source. 
NeoBundle 'Shougo/neoyank.vim'

" also see source register
let g:unite_source_history_yank_enable = 1
let g:unite_source_history_yank_save_clipboard = 1
" let g:unite_source_history_yank_limit = 100
" let g:unite_source_history_yank_file = TODO

nnoremap <silent> <leader>yy :Unite
    \ -buffer-name=unit-yank
    \ -no-auto-preview
    \ -default-action=append
    \ history/yank
    \ <cr>

nnoremap <silent> <leader>yr :Unite
    \ -buffer-name=unit-yank
    \ -no-auto-preview
    \ -no-start-insert
    \ register
    \ <cr>

