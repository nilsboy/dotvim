" Improved incremental searching for Vim
PackAdd haya14busa/incsearch.vim

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


let g:incsearch#do_not_save_error_message_history = 1
let g:incsearch#magic = '\M' " nomagic
" let g:incsearch#magic = '\v' " very magic
" let g:incsearch#emacs_like_keymap = 1
" let g:incsearch#separate_highlight = 1
