let &errorformat = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg = "prettier --parser json --write --loglevel error --prose-wrap=always % 2>&1"

let &makeprg .= " \\| errorformatregex --filename " . expand("%:p")

" [error] openapi/product-offering-v1.openapi.yaml: SyntaxError: Implicit map keys need to be on a single line (2:1)
" [error]   1 | openapi: 3.0.1
" [error] > 2 | info
" [error]     | ^^^^
" [error] > 3 |   title: Product offering
" [error]     | ^^^^^^^^

let &makeprg .= " 'e/^\\[error\\].+\\s+\\((?<row>\\d+)\\:(<col>\\d+)\\)$/gm'"
let &makeprg .= " 'e/^\/bin\/bash/gm'"

if exists("prettier-json#loaded")
  finish
endif
let prettier-json#loaded = 1

MyInstall prettier
MyInstall errorformatregex npm install -g @nilsboy/errorformatregex
