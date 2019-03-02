nnoremap <silent><buffer> <leader>x :call MyXmlTidy()<CR>

let &l:define = '\v(<bean\ id=|<alias\ name=)'
let &l:define = '\v(<bean\ id=)'
