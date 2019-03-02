" A Git wrapper so awesome, it should be illegal
" TAGS: git
PackAdd tpope/vim-fugitive

nnoremap <silent> <leader>gs :Gstatus<cr>
nnoremap <silent> <leader>gd :Gvdiff<cr>
nnoremap <silent> <leader>gc :Gcommit<cr>
nnoremap <silent> <leader>gb :Gblame<cr>
nnoremap <silent> <leader>gl :Glog<cr>
nnoremap <silent> <leader>gp :Git push<cr>
nnoremap <silent> <leader>gw :Gwrite<cr>
nnoremap <silent> <leader>gr :Gremove<cr>
nnoremap <silent> <leader>ga :!git add -A .<cr>
nnoremap <silent> <leader>gD :call MyFugitiveProjectDiff()<cr>

function! MyFugitiveProjectDiff() abort
  Redir !git diff
  setlocal filetype=diff
endfunction

