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

"### file_rec #################################################################

nnoremap <silent> <leader>ff call Uniteff()<cr>

function! Uniteff()

    execute "Unite file_rec:" . $HOME . "/src"

"             \ -buffer-name=hostfiles
"             \ -no-quit
"             \ -keep-focus
"             \ -immediately
"             \ -start-insert
"             \ -silent
"             \ file_rec:" . $HOME . "/src"<cr>
endfunction
