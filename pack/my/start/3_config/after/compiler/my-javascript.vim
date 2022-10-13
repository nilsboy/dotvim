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

