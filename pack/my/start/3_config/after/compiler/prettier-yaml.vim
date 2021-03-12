MyInstall prettier
MyInstall errorformatregex npm install -g @nilsboy/errorformatregex

let &errorformat = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg = "prettier --parser yaml --write --loglevel error --print-width=80 --prose-wrap=always % 2>&1"

let &makeprg .= " \\| errorformatregex --filename " . expand("%:p")

" [error] openapi/product-offering-v1.openapi.yaml: SyntaxError: Implicit map keys need to be on a single line (2:1)
" [error]   1 | openapi: 3.0.1
" [error] > 2 | info
" [error]     | ^^^^
" [error] > 3 |   title: Product offering - Produktangebote
" [error]     | ^^^^^^^^

let &makeprg .= " 'e/^\\[error\\].+\\s+\\((?<row>\\d+)\\:(?<col>\\d+)\\)$/gm'"
