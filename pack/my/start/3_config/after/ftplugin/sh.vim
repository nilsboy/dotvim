" keywordprg only works for external apps
nnoremap <buffer><silent>K :call Man(expand("<cword>"))<cr>

let &l:define = '\v^(##+\s|function|alias)'
let b:outline = '^(##+\s|function|alias)'

let b:my_tbone_clear=1
