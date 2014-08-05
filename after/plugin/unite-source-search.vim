call unite#custom#source('line', 'sorters', ['sorter_nothing'])

nnoremap <silent> // :<C-u>Unite
            \ -buffer-name=search
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -start-insert
            \ -silent
            \ line<cr>
