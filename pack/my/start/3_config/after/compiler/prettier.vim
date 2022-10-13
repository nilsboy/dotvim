MyInstall prettier
MyInstall errorformatregex npm install -g @nilsboy/errorformatregex

let &errorformat = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg = "prettier"
let &makeprg .= " --write"
let &makeprg .= " --loglevel=error"
let &makeprg .= " --arrow-parens=always"
let &makeprg .= " --no-semi"
let &makeprg .= " --trailing-comma=es5"

let &makeprg .= " " . expand("%:p") . " 2>&1"

let &makeprg .= " \\| errorformatregex --filename " . expand("%:p")

