" incremantal fuzzy search extension for incsearch.vim
PackAdd haya14busa/incsearch-fuzzy.vim

nmap <leader>/z <Plug>(incsearch-fuzzy-/)
nmap <leader>/z? <Plug>(incsearch-fuzzy-?)

" does not move cursor
nmap <leader>/zg <Plug>(incsearch-fuzzy-stay)

" nmap z/ <Plug>(incsearch-fuzzy-/)
" nmap z? <Plug>(incsearch-fuzzy-?)
" nmap zg/ <Plug>(incsearch-fuzzy-stay)
