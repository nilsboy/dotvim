" A Git wrapper so awesome, it should be illegal
" TAGS: git
" TBD: checkout vim-flog, git-jump
" SEE ALSO: ~/.gitconfig

PackAdd tpope/vim-fugitive

nnoremap <leader>gH :execute "edit " . stdpath('config')
  \ . "/pack/my/start/2_plugin_config/plugin/vim-fugitive.vim"<cr>
 
nnoremap <silent> <leader>gs :Git<cr>
nnoremap <silent> <leader>gD :Gvdiffsplit! \| echo 'target branch (current) / working copy / merge branch (other)'<cr>

" diff staging @=HEAD
nnoremap <silent> <leader>gd :silent Gvdiffsplit! @   \| echo 'target branch (current) / working copy / merge branch (other)'<cr>
nnoremap <silent> <leader>gm :Gvdiffsplit! dev \| echo 'target branch (current) / working copy / merge branch (other)'<cr>

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

" TBD:
" nnoremap <silent> <leader>gM :call MyFugitiveMasterDiff()<cr>
function! MyFugitiveMasterDiff() abort
  call nb#createTempBuffer('GitDiffMaster', '', 'diff')
  " TBD: git command not working:
  put!=execute('!git diff main...')
  normal! gg
  " setlocal filetype=diff
endfunction

" nnoremap <silent> <leader>gg :call MakeWith({'name': 'myrunprg', 'compiler': 'git-status', 'args': ''})<cr>
" nnoremap <silent> <leader>fg :let &g:errorformat = '%f' \| cgetexpr system('git diff-files --name-only --diff-filter=d') \| :copen<cr>

nnoremap <silent> <leader>gS :let &g:errorformat = '%f' \| cgetexpr system('git diff --name-only --diff-filter=d main --') \| :copen<cr>

" diff --name-only dev -- 

" nnoremap <silent> <leader>gg :cexpr system('git diff --name-status main')
nnoremap <silent> <leader>gg :call MakeWith({'compiler': 'git-diff-branch'})<cr>

