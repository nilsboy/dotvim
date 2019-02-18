" tbone.vim: tmux basics
PackAdd tpope/vim-tbone
" TAGS: tmux shell command line

let g:tbone_write_pane = '.last'

nnoremap <silent> <leader>mw :Tmux display-panes \| :let g:tbone_write_pane = '.last'<cr>
vnoremap <silent> <leader>mm :'<,'>Twrite<cr>
nnoremap <silent> <leader>mm :.Twrite<cr>
nnoremap <silent> <leader>mp vip:'<,'>Twrite<cr>
