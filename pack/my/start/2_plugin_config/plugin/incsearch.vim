" Improved incremental searching for Vim
PackAdd haya14busa/incsearch.vim

nmap /  <Plug>(incsearch-forward)
nmap ?  <Plug>(incsearch-backward)
nmap g/ <Plug>(incsearch-stay)

set hlsearch
let g:incsearch#auto_nohlsearch = 1
nmap n  <Plug>(incsearch-nohl-n)
nmap N  <Plug>(incsearch-nohl-N)
nmap *  <Plug>(incsearch-nohl-*)
nmap #  <Plug>(incsearch-nohl-#)
nmap g* <Plug>(incsearch-nohl-g*)
nmap g# <Plug>(incsearch-nohl-g#)


let g:incsearch#do_not_save_error_message_history = 1
let g:incsearch#magic = '\M' " nomagic
" let g:incsearch#magic = '\v' " very magic
" let g:incsearch#emacs_like_keymap = 1
" let g:incsearch#separate_highlight = 1
