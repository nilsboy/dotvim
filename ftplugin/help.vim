if exists("b:did_ftplugin_help")
    finish
endif
let b:did_ftplugin_help = 1

"Simplify help navigation"
"(http://vim.wikia.com/wiki/Learn_to_use_help)

nnoremap <buffer> <CR> <C-]>
nnoremap <buffer> <BS> <C-T>
nnoremap <buffer> o /'\l\{2,\}'<CR>
nnoremap <buffer> O ?'\l\{2,\}'<CR>
nnoremap <buffer> s /\|\zs\S\+\ze\|<CR>
nnoremap <buffer> S ?\|\zs\S\+\ze\|<CR>

setlocal buflisted
setlocal keywordprg=:help

