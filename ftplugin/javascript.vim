if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

map <buffer><silent><leader>w :call JSTidy()<CR><CR><silent> :SyntasticCheck<cr>

" Tab spacing
setl tabstop=2

" Shift width (moved sideways for the shift command)
setl shiftwidth=2

letl &makeprg="npm run"

" install npm install standard -g
" https://github.com/feross/standard
let g:syntastic_javascript_checkers=['standard']

" nnoremap <buffer> <silent> K :TernDoc<CR>

" node run files
" TODO autocmd filetype javascript nnoremap <Leader>c :w <CR>:!node %<CR>
