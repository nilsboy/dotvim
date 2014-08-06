call unite#custom#source('file_rec', 'converters', ['converter_default'])
call unite#custom#source('file_rec', 'sorters', ['sorter_word'])

" no file limit
" fails: call unite#custom#source('file_rec' 'max_candidates', 0)
let g:unite_source_rec_max_cache_files = 0

nnoremap <silent> <leader>f :<C-u>Unite
            \ -buffer-name=files
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -start-insert
            \ -silent
            \ file_rec<cr>

"### file_rec #################################################################

nnoremap <silent> <leader>ff :call Uniteff()<cr>

function! Uniteff()
    execute "Unite -silent -start-insert file_rec:" . $HOME . "/src"
endfunction
