" " TODO: use coc-yaml with an openapi schema instead
" augroup MyOpenApiAugroupLint
"   autocmd!
"   " TBD: TextChanged stops UltiSnips snippet expansion
"   " autocmd TextChanged,InsertLeave * :call MyOpenApiLint()
"   " autocmd BufWritePost <buffer> :compiler lint-openapi | silent lmake! | lwindow
"   autocmd BufWritePost <buffer> :silent call MakeWith({'name': 'lint-openapi', 'compiler': 'lint-openapi', 'loclist': 0})
" augroup END

" let b:outline = '^(\s\s[/\w"]|\w|\s+(\/|post|get|put|patch|delete)|\s{4}[\w"]+\:)'
let b:outline = '('
" let b:outline .= '^\w+.*\:|^  \w+.*\:|^\s+\/|^\s+(post|get|patch|delete|put)\:'
" let b:outline .= '^\w+.*\:$'
" let b:outline .= '|^    \S+.*\:$'
let b:outline .= '^\s{0,4}\S+.*\:$'
let b:outline .= ')'

let b:formatter = 'prettier-yaml'

nnoremap <silent> <leader>X :silent call MakeWith({'name': 'lint-openapi-spectral', 'compiler': 'lint-openapi-spectral', 'loclist': 0})<cr>

" render html output:
" :CocCommand swagger.render
