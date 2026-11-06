let &errorformat = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg = "git diff --name-status main 2>&1"
let &makeprg .= " \\| sort "
let &makeprg .= " \\| errorformatregex"

" M       README.md
let &makeprg .=   " 'i/^A\\s+(?<file>.+)$/gm'"
let &makeprg .=   " 'n/^M\\s+(?<file>.+)$/gm'"
let &makeprg .=   " 'e/^D\\s+(?<file>.+)$/gm'"

MyInstall errorformatregex npm install -g @nilsboy/errorformatregex

