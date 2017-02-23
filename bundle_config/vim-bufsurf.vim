finish
" enables surfing through buffers based on viewing history per window
NeoBundle 'ton/vim-bufsurf'
" NOTE: also reopens files
" NOTE: seems to miss the first buffer (2017-02-23)

nmap <silent>H :BufSurfBack<cr>
nmap <silent>L :BufSurfForward<cr>

" let g:BufSurfIgnore = '\[unite\]'
