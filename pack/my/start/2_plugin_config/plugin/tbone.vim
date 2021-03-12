" tbone.vim: tmux basics
PackAdd tpope/vim-tbone
" TAGS: tmux shell command line

" make last visited pane the tbone target pane
function! tbone#setTargetPane() abort
  let g:my_tbone_pane = tbone#pane_id('.last')
  let g:my_tbone_target = ' -t ' . g:my_tbone_pane . ' '
  let g:tbone_write_pane = g:my_tbone_pane
  " Tmux display-panes
endfunction
nnoremap <silent> <leader>mp :call tbone#setTargetPane() \
  \| Tmux display-panes <cr>
call tbone#setTargetPane()

function! tbone#clear() abort
  execute 'Tmux send-keys ' . g:my_tbone_target . ' C-c C-l clear C-m'
endfunction

function! tbone#mm() abort
  call tbone#clear()
  " silent supresses 'xx keys sent to' messages
  silent execute a:firstline . ',' . a:lastline . 'Twrite'
endfunction

" nnoremap <silent> <leader>mm vip:'<,'>Twrite<cr>
nnoremap <silent> <leader>mm vip:call tbone#mm()<cr>
vnoremap <silent> <leader>mm :'<,'>Twrite<cr>

nnoremap <silent> <leader>ml :.Twrite<cr>
nnoremap <silent> <leader>mc :call tbone#clear()<cr>

" open shell in current buffers directory
nnoremap <silent> <leader>md :execute ":Tmux split-window -v 'cd " . expand('%:h') . " && bash -i'"<cr>

" ls
