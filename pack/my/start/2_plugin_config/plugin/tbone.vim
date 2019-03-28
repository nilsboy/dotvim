" tbone.vim: tmux basics
PackAdd tpope/vim-tbone
" TAGS: tmux shell command line

let g:tbone_write_pane = '.last'

" make current pane the tbone default target pane
nnoremap <silent> <leader>mw :Tmux display-panes \| :let g:tbone_write_pane = '.last'<cr>

vnoremap <silent> <leader>mm :'<,'>Twrite<cr>
nnoremap <silent> <leader>mm :.Twrite<cr>
nnoremap <silent> <leader>mp vip:'<,'>Twrite<cr>

" open shell in current buffers directory
nnoremap <silent> <leader>md :execute ":Tmux split-window -v 'cd " . expand('%:h') . " && bash -i'"<cr>
