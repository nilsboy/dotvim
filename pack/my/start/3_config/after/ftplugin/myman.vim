let b:outline = '(^(\-\-\-)\s+|^[[:upper:]]+[[:upper:]\s]$|^\s{2,}\-{1,2}\w)'
let b:outline = '^(\-\-\-)\s+'
let b:outline = '^\w+'

" keywordprg only works for external apps
nmap <buffer><silent>K :call Man(expand("<cword>"))<cr>
