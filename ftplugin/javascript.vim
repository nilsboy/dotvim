map <buffer><silent><leader>w :call JSTidy()<CR><CR><silent> :SyntasticCheck<cr>

" Tab spacing
set tabstop=2

" Shift width (moved sideways for the shift command)
set shiftwidth=2

let &makeprg="npm run"

" install npm install standard -g
" https://github.com/feross/standard
let g:syntastic_javascript_checkers=['standard']

" nnoremap <buffer> <silent> K :TernDoc<CR>

" Nodejs dictionary, used by neocomplete through omnicomplete
autocmd FileType javascript set dictionary+=$MY_VIM_BUNDLE/bundle/vim-node/dict/node.dict

" node run files
" TODO autocmd filetype javascript nnoremap <Leader>c :w <CR>:!node %<CR>
