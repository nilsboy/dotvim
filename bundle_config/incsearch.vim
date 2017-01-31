" Currently segfaults neovim (2017-01-25):
" https://github.com/haya14busa/incsearch.vim/issues/125
finish
" Improved incremental searching for Vim
" tags: search stophighlight
NeoBundle 'haya14busa/incsearch.vim'

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
