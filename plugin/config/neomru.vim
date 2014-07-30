call unite#custom#source('neomru/file', 'converters', ['converter_file_directory'])
" call unite#custom#source('neomru/file', 'sorters', ['sorter_nothing'])
call unite#custom#source('neomru/file', 'sorters', ['sorter_ftime', 'sorter_reverse'])

nnoremap <silent> <leader>r :<C-u>Unite
            \ -buffer-name=mru
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -start-insert
            \ -silent
            \ neomru/file<cr>

" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | :<C-u>Unite neomru/file<cr> | endif
" nnoremap <silent> <leader>v :<C-u>Unite
