call unite#custom#source('neomru/file', 'converters', ['converter_file_directory'])
call unite#custom#source('neomru/file', 'sorters', ['sorter_nothing'])

nnoremap <silent> <leader>r :<C-u>Unite
            \ -buffer-name=mru
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -start-insert
            \ -silent
            \ neomru/file<cr>

autocmd StdinReadPre * let s:std_in=1
augroup vimEnter_mru
    autocmd!
    autocmd VimEnter * if argc() == 0 && exists("s:std_in") == 0 | :exe 'Unite neomru/file' | endif
augroup END


