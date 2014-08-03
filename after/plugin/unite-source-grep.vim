call unite#custom#source('vimgrep', 'converters', ['converter_default'])
" call unite#custom#source('vimgrep', 'sorters', ['sorter_word'])

nnoremap <silent> <Leader>g :<C-u>Unite
            \ -buffer-name=grep
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -silent
            \ vimgrep:**<cr>
