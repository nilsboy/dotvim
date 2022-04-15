augroup MyOpenApiAugroupLint
  autocmd!
  " TODO: TextChanged stops UltiSnips snippet expansion
  " autocmd TextChanged,InsertLeave * :call MyOpenApiLint()
  autocmd BufWritePost <buffer> :compiler lint-openapi | silent lmake! | lwindow
augroup END

" let b:outline = '^(\s\s[/\w"]|\w|\s+(\/|post|get|put|patch|delete)|\s{4}[\w"]+\:)'
let b:outline = '('
" let b:outline .= '^\w+.*\:|^  \w+.*\:|^\s+\/|^\s+(post|get|patch|delete|put)\:'
" let b:outline .= '^\w+.*\:$'
" let b:outline .= '|^    \S+.*\:$'
let b:outline .= '^\s{0,4}\S+.*\:$'
let b:outline .= ')'



let b:formatter = 'prettier-yaml'
