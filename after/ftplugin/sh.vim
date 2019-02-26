" keywordprg only works for external apps
nmap <buffer><silent>K :call Man(expand("<cword>"))<cr>

let &l:define = '\v^(##+\s|function|alias)'
