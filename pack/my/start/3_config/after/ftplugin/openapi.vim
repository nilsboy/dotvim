augroup MyOpenApiAugroupLint
  autocmd!
  " TODO: TextChanged stops UltiSnips snippet expansion
  " autocmd TextChanged,InsertLeave * :call MyOpenApiLint()
  autocmd BufWritePost <buffer> :compiler lint-openapi | silent lmake! | lwindow
augroup END


let b:outline = '^(  /|  \w.+\:|    (post|get|put|patch|delete)\:)'
let b:outline = '^(\s\s[/\w]|\w).+$'

let b:formatter = 'prettier-yaml'

let g:neoformat_open_api_prettier = {
      \ 'exe': 'prettier'
      \ ,'args': ['--prose-wrap=always']
      \ }

let g:neoformat_enabled_open_api = [ 'prettier' ]

