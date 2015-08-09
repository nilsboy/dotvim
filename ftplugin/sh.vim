if exists("b:did_ftplugin_sh")
    finish
endif
let b:did_ftplugin_sh = 1

" keywordprg only works for external apps
nmap <buffer><silent>K :call Man(expand("<cword>"))<cr><cr>
