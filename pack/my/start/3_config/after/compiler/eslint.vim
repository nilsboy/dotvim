" eslint can not format from stdin - only lint.
" Errors are reported to stdout never to stderr. Specifying --quiet suppresses
" them completely.
" The result can not be send to stdout - the file is changed in place.

" MyInstall errorformatregex npm install -g @nilsboy/errorformatregex

MyInstall eslint npm install -g eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin@latest

let &errorformat = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg = "eslint"
let &makeprg .= " -f unix"
" let &makeprg .= " --no-eslintrc"
let &makeprg .= " -c " . $CONTRIB . '/eslintrc-typescript.json'
" let &makeprg .= " --replace=1"
" let &makeprg .= " --fix"
" let &makeprg .= " --quiet"

let &makeprg .= " " . expand("%:p") . " 2>&1"

let &makeprg .= " \\| errorformatregex --filename " . expand("%:p")

" Oops! Something went wrong! :(
let &makeprg .= " 'e/Oops\!/igm'"
