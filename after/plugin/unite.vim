"### general ##################################################################

let g:unite_data_directory = VIM_VAR . "unite"

" no clue - but complains if not set
let g:unite_abbr_highlight = "function"

let g:unite_source_history_yank_enable = 1

" call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#converter_default#use(['converter_file_directory'])
call unite#filters#sorter_default#use(['sorter_word'])

" TODO
" checkout source output:messages
" nnoremap <leader>y :<C-u>Unite -buffer-name=yank    history/yank<cr>
" nnoremap <leader>x :<C-u>UniteWithBufferDir -buffer-name=files   -start-insert file_rec<cr>
" nnoremap <leader>c :<C-u>UniteWithCursorWord -buffer-name=files -immediately file_rec<cr>
" nnoremap <leader>b :<C-u>:UniteBookmarkAdd<cr>

"### line #####################################################################

call unite#custom#source('line', 'sorters', ['sorter_nothing'])

nnoremap <silent> // :<C-u>Unite
            \ -buffer-name=search
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -start-insert
            \ -silent
            \ line<cr>

"### buffers ##################################################################

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

"### file_rec #################################################################

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
