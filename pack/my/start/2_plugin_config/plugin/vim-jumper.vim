" Vim plugin for improved search highlighting
PackAdd nilsboy/vim-jumper

nmap <silent> H <Plug>(jumper-back)
nmap <silent> L <Plug>(jumper-forward)

nmap <silent> <leader>jj <Plug>(jumper-history)

let g:vim_jumper_persist = 0
