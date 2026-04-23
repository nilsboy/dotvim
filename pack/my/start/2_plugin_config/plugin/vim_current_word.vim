" TBD: only highlight on cursor hold
" highlighting word under cursor and all of its occurences
PackAdd dominikduda/vim_current_word

" NOTE: needed - scrolling is slow otherwise.
" Probably needs to be higher than the keyboard repeat rate.
let g:vim_current_word#highlight_delay = 100

let g:vim_current_word#enabled = 1

let g:vim_current_word#highlight_current_word = 1
let g:vim_current_word#highlight_twins = 1

" NOTE: test for big files?:
" let g:vim_current_word#highlight_delay = 0

highlight! link CurrentWord MoreMsg
highlight! link CurrentWordTwins MoreMsg
