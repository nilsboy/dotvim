let g:unite_data_directory = VIM_VAR . "unite"

" no clue - but complains if not set
let g:unite_abbr_highlight = "function"

let g:unite_source_history_yank_enable = 1

" call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#converter_default#use(['converter_file_directory'])
call unite#filters#sorter_default#use(['sorter_word'])

nnoremap <silent> // :<C-u>Unite
            \ -buffer-name=search
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -start-insert
            \ -silent
            \ line<cr>

nnoremap <silent> <leader>v :<C-u>Unite
            \ -buffer-name=vimfos
            \ -no-quit
            \ -keep-focus
            \ -immediately
            \ -start-insert
            \ -silent
            \ tab window buffer<cr>

" nnoremap <leader>y :<C-u>Unite -buffer-name=yank    history/yank<cr>
" nnoremap <leader>x :<C-u>UniteWithBufferDir -buffer-name=files   -start-insert file_rec<cr>
" nnoremap <leader>c :<C-u>UniteWithCursorWord -buffer-name=files -immediately file_rec<cr>
" nnoremap <leader>b :<C-u>:UniteBookmarkAdd<cr>

" register
" :UniteWithProjectDir
" \ -auto-preview
" \ -quick-match
" \ -hide-sources-names
" \ -hide-status-line - no works?
" \ -here -no-resize
" -unique
" source: menu
