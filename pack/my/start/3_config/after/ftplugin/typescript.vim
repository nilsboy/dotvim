let &l:define = '\v^\s*(interface|declare|type|export)\s'
let b:outline = '^\s*(interface|class|declare|type|export|function|async function|describe|beforeAll|it)[\s\(]+'

nnoremap <silent> <buffer> K :call CocAction('doHover')<cr>
