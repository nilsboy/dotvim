" highlighting word under cursor and all of its occurences
PackAdd dominikduda/vim_current_word

let g:vim_current_word#enabled = 1

let g:vim_current_word#highlight_current_word = 0
let g:vim_current_word#highlight_twins = 1

" highlight! link CurrentWord Normal
highlight! link CurrentWordTwins MoreMsg
