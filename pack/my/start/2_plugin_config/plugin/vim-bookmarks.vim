" Vim bookmark plugin
" NOTE: no mapping to jump between files.
finish

" let g:bookmark_no_default_key_mappings = 1
" let g:bookmark_save_per_working_dir = 1

nmap <silent> H <Plug>BookmarkNext
nmap <silent> L <Plug>BookmarkPrev

PackAdd MattesGroeger/vim-bookmarks
