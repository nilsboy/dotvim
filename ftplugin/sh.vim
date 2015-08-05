if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

nnoremap <buffer> <silent> K :call Man(expand("<cword>"))<cr><cr>
