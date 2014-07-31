call unite#custom#source('file_rec', 'converters', ['converter_default'])
call unite#custom#source('file_rec', 'sorters', ['sorter_word'])

nnoremap <silent> <leader>f :<C-u>Unite
            \ -buffer-name=files
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -start-insert
            \ -silent
            \ file_rec<cr>

nnoremap <silent> <leader>ff :<C-u>Unite
            \ -buffer-name=files
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -start-insert
            \ -silent
            \ file_rec $HOME/src<cr>
