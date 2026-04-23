let &l:define = '\v(public|private)\s*(.*class|.*\w+\()'

let b:outline = '('
let b:outline .= '^\s*class\s.*$'
let b:outline .= '|^\s*(final|protected|public|private)+\s.*[{)]+\s*$'
let b:outline .= ')'

let &l:include = '\vimport\s+'

nnoremap <buffer> <silent> K :call CocAction('doHover')<cr>
nmap <silent> <leader>lL <Plug>(coc-float-jump)

nnoremap <silent> <buffer> <leader>lw :silent call MakeWith({'name': 'mvn', 'compiler': 'mvn'})<cr>
nnoremap <silent> <buffer> <leader>lo :call CocActionAsync('runCommand', 'editor.action.organizeImport')<cr>
