let &errorformat = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg = "git status -s"

" output:
" M ../package.json
" ?? file

let &makeprg .= " \\| errorformatregex "
let &makeprg .= " 'n/^...(?<file>.+)$/igm'"
