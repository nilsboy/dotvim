call unite#custom#source('tab', 'sorters', ['sorter_nothing'])
call unite#custom#source('window', 'sorters', ['sorter_nothing'])
call unite#custom#source('buffer', 'sorters', ['sorter_nothing'])

nnoremap <silent> <leader>v :<C-u>Unite
            \ -buffer-name=vimfos
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -silent
            \ tab window buffer<cr>
