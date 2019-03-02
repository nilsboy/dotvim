" setlocal nowrap
setlocal syntax=txt

nmap <buffer><silent>K :call Man(expand("<cword>"))<cr><cr>
