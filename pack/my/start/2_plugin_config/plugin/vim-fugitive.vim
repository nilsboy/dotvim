" A Git wrapper so awesome, it should be illegal
" TAGS: git
" TBD: checkout vim-flog, git-jump
PackAdd tpope/vim-fugitive

nnoremap <silent> <leader>gs :Git<cr>
nnoremap <silent> <leader>gd :Gvdiffsplit! \| echo 'target branch (current) / working copy / merge branch (other)'<cr>
" TODO:
nnoremap <silent> <leader>gm :call MyFugitiveMasterDiff()<cr>
nnoremap <silent> <leader>gc :Git commit<cr>
nnoremap <silent> <leader>gB :Git blame<cr>
nnoremap <silent> <leader>gi :GBrowse<cr>

" unstage file
nnoremap <silent> <leader>gu :!git reset -- %<cr>

" nnoremap <silent> <leader>gl :GV<cr>
" nnoremap <silent> <leader>gl :Glog! --<cr><cr>:copen<cr>
nnoremap <silent> <leader>gll :silent Gclog! --<cr>:copen<cr>

nnoremap <silent> <leader>glb :Gclog! --graph --all --<cr>

" find changes
nnoremap <leader>gls :Gclog! -S --<left><left><left>

" changes of file
nnoremap <silent> <leader>glf :%Gclog! \| copen<cr>

nnoremap <silent> <leader>gp :Git push<cr>
nnoremap <silent> <leader>gw :Gwrite<cr>
nnoremap <silent> <leader>gW :Gwrite!<cr>
nnoremap <silent> <leader>gr :GRemove<cr>

nnoremap <silent> <leader>ga :silent !git add %<cr>
nnoremap <silent> <leader>gA :silent !git add -A .<cr>

nnoremap <silent> <leader>gC :!git checkout %<cr>

" nnoremap <silent> <leader>gg :call Redir("!git log --graph --simplify-by-decoration --date=\"format:%F %T\" --pretty=format:\"%d %s \| %ad \| %h\" --all", 0, 0) \| set filetype=git-branches<cr>
" nnoremap <silent> <leader>gB :call Redir("!git log --graph --oneline --decorate --all", 0, 0) \| set filetype=git-branches<cr>

" nnoremap <silent> <leader>gb :Twiggy<cr>

function! MyFugitiveMasterDiff() abort
  Redir !git diff master
  setlocal filetype=diff
endfunction

command! -nargs=* SyntaxOffBuffer setlocal syntax=off
