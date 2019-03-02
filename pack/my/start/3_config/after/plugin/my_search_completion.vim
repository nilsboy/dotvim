finish
" Search suggestions auto complete
" https://www.reddit.com/r/vim/comments/8bguck/tip_search_suggestions_auto_complete/

function! s:search_mode_start()
    cnoremap <tab> <c-f>a<c-n>
    let s:old_complete_opt = &completeopt
    set completeopt-=noinsert
endfunction

function! s:search_mode_stop()
    cunmap <tab>
    let &completeopt = s:old_complete_opt
endfunction

autocmd CmdlineEnter [/\?] call <SID>search_mode_start()
autocmd CmdlineLeave [/\?] call <SID>search_mode_stop()
