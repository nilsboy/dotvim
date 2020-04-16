let &l:define = '\v^\s*(interface|declare|type|export)\s'
let b:outline = '^\s*(interface|class|declare|type|export|function)\s'

nnoremap <silent> <buffer> K :call CocAction('doHover')<cr>
