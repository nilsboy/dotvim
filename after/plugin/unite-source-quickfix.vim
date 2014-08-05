" call unite#custom#source('outline', 'converters', ['converter_default'])
" call unite#custom#source('outline', 'sorters', ['sorter_word'])

nnoremap <silent> <Leader>q :<C-u>Unite
            \ -buffer-name=qf
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -silent
            \ qf<cr>
