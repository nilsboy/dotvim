if exists("b:did_ftplugin_javascript")
    finish
endif
let b:did_ftplugin_javascript = 1

map <buffer><silent><leader>w :call JSTidy()<CR><CR>
" <silent> :SyntasticCheck<cr>

" Tab spacing
setlocal tabstop=2

" Shift width (moved sideways for the shift command)
setlocal shiftwidth=2

setlocal makeprg="npm run"

" install npm install standard -g
" https://github.com/feross/standard
" let g:syntastic_javascript_checkers=['standard']

" nnoremap <buffer> <silent> K :TernDoc<CR>

" node run files
" TODO autocmd filetype javascript nnoremap <Leader>c :w <CR>:!node %<CR>
