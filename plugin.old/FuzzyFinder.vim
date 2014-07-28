"if ! exists("g:fuf_dataDir")
"if ! exists(":FufBufferTag")
"    finish
"endif

let g:fuf_dataDir = VIM_VAR . "fuzzy-finder"

"map <silent> <Leader>o :FufBufferTag<CR>
"map <silent> <Leader>t :FufTag<CR>
"map <silent> <Leader>f :FufFile **/<CR>
"map <silent> <Leader>j :FufJumpList<CR>
"map <silent> <Leader>l :FufLine<CR>

" map <silent> / :FufLine<CR>
" map <silent> <c-t> :FufBufferTagWithCursorWord<CR>
