finish

" ack support
NeoBundle 'mileszs/ack.vim'

let g:ackprg="ack -H --nocolor --nogroup --column --smart-case --sort-files"
let g:ackhighlight = 1

" nnoremap <Leader>s :Ack 
" nnoremap <Leader>g :Ack<CR>
