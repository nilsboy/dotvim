MyInstall prettier
MyInstall eslint
MyInstall errorformatregex npm install -g @nilsboy/errorformatregex

" not tested jet
finish

let &errorformat = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg  = "my_javascript_formatter"
let &makeprg .= " % 2>&1"

" let &makeprg .= " \\| errorformatregex --filename " . expand("%:p")
" TODO:
let &makeprg .= " \\| errorformatregex"

" [error] openapi/product-offering-v1.openapi.yaml: SyntaxError: Implicit map keys need to be on a single line (2:1)
" [error]   1 | openapi: 3.0.1
" [error] > 2 | info
" [error]     | ^^^^
" [error] > 3 |   title: Product offering - Produktangebote
" [error]     | ^^^^^^^^

let &makeprg .= " 'e/^\\[error\\].+\\s+\\((?<row>\\d+)\\:(?<col>\\d+)\\)$/gm'"

