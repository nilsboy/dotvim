" Improved incremental searching for Vim
" Alternative: vim-cool
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
" let g:incsearch#separate_highlight = 1

" nomagic 
let g:incsearch#magic = '\M'

augroup incsearch-keymap
  autocmd!
  autocmd VimEnter * call s:incsearch_keymap()
augroup END
function! s:incsearch_keymap()
  IncSearchNoreMap <Tab> <Over>(buffer-complete)
  IncSearchNoreMap <S-Tab> <Over>(buffer-complete-prev)
  IncSearchNoreMap <c-g> <Over>(incsearch-next)
  IncSearchNoreMap <c-t> <Over>(incsearch-prev)
endfunction
