" A Git wrapper so awesome, it should be illegal
" TAGS: git
" TBD: checkout vim-flog, git-jump
PackAdd tpope/vim-fugitive

nnoremap <silent> <leader>gs :Gstatus<cr>
nnoremap <silent> <leader>gd :Gvdiff<cr>
nnoremap <silent> <leader>gD :call MyFugitiveProjectDiff()<cr>
nnoremap <silent> <leader>gm :call MyFugitiveMasterDiff()<cr>
nnoremap <silent> <leader>gc :Gcommit<cr>
nnoremap <silent> <leader>gB :Gblame<cr>
nnoremap <silent> <leader>gi :Gbrowse<cr>

" unstage file
nnoremap <silent> <leader>gu :!git reset -- %<cr>

" nnoremap <silent> <leader>gl :GV<cr>
" nnoremap <silent> <leader>gl :Glog! --<cr><cr>:copen<cr>
nnoremap <silent> <leader>gll :silent Glog! --<cr>:copen<cr>

nnoremap <silent> <leader>glb :silent Glog! --graph --all --<cr>

" find changes
nnoremap <leader>gls :Glog! -S  --<left><left><left>

" changes of file
nnoremap <silent> <leader>glf :%Gclog! \| copen<cr>

nnoremap <silent> <leader>gp :Git push<cr>
nnoremap <silent> <leader>gw :Gwrite<cr>
nnoremap <silent> <leader>gr :Gremove<cr>

nnoremap <silent> <leader>ga :silent !git add %<cr>
nnoremap <silent> <leader>gA :silent !git add -A .<cr>

nnoremap <silent> <leader>gC :!git checkout %<cr>

" nnoremap <silent> <leader>gg :call Redir("!git log --graph --simplify-by-decoration --date=\"format:%F %T\" --pretty=format:\"%d %s \| %ad \| %h\" --all", 0, 0) \| set filetype=git-branches<cr>
" nnoremap <silent> <leader>gB :call Redir("!git log --graph --oneline --decorate --all", 0, 0) \| set filetype=git-branches<cr>

" nnoremap <silent> <leader>gb :Twiggy<cr>

function! MyFugitiveProjectDiff() abort
  Redir !git diff
  setlocal filetype=diff
endfunction

function! MyFugitiveMasterDiff() abort
  Redir !git diff master
  setlocal filetype=diff
endfunction
