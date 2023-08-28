runtime! after/ftplugin/javascript.vim

let &l:commentstring = '// %s'

" NOTE: change for word under cursor
setl iskeyword-=$

let b:formatter = 'prettier'
let b:outline = '^//\s+'

nmap <buffer> <leader>nrj viC:MyNrrwRgn json<cr>
nmap <buffer> <leader>nrr viC:MyNrrwRgn javascript<cr>
