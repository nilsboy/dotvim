finish
" Improved incremental searching for Vim
" NeoBundle 'haya14busa/incsearch.vim'

" NOTE: Currently segfaults neovim (2017-01-25):
"   https://github.com/haya14busa/incsearch.vim/issues/125
" TAGS: search stophighlight
" use fork until main repo has workaround or neovim gets fixed
" still seems to be buggy
NeoBundle 'xeyownt/incsearch.vim'

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

set hlsearch
let g:incsearch#auto_nohlsearch = 1
" map n  <Plug>(incsearch-nohl-n)
" map N  <Plug>(incsearch-nohl-N)
" map *  <Plug>(incsearch-nohl-*)
" map #  <Plug>(incsearch-nohl-#)
" map g* <Plug>(incsearch-nohl-g*)
" map g# <Plug>(incsearch-nohl-g#)
