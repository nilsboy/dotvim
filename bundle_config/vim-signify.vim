" Show a diff using Vim its sign column.
NeoBundle 'mhinz/vim-signify'
" NOTES: replace with quickfix?
" TAGS: git

let g:signify_disable_by_default = 1
" nnoremap <leader>gc :SignifyToggleHighlight<cr>
nnoremap <leader>gc :SignifyToggle<cr>
