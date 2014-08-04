"Simplify help navigation"
"(http://vim.wikia.com/wiki/Learn_to_use_help)

nnoremap <buffer> <CR> <C-]>
nnoremap <buffer> <BS> <C-T>
nnoremap <buffer> o /'\l\{2,\}'<CR>
nnoremap <buffer> O ?'\l\{2,\}'<CR>
nnoremap <buffer> s /\|\zs\S\+\ze\|<CR>
nnoremap <buffer> S ?\|\zs\S\+\ze\|<CR>

" Open help fullscreen
" set helpheight=99999

" Make help buffers listed to be able to switch to them via :bnext etc.
" @deprecated: done for all buffers now in vimrc
" augroup filetype_help
    " autocmd!
    " autocmd BufWinEnter * if &l:buftype ==# 'help' | set buflisted | endif
    " autocmd BufAdd * set buflisted
" augroup END
