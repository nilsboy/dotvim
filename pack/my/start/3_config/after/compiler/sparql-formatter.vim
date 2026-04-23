" NOTE: currently only used as linter as the formatted output is too indenty

MyInstall sparql-formatter npm install -g sparql-formatter
MyInstall errorformatregex npm install -g @nilsboy/errorformatregex

let &errorformat = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg = "sparql-formatter"

let &makeprg .= " " . expand("%:p") . " 2>&1"

let &makeprg .= " \\| errorformatregex --filename " . expand("%:p")

" SyntaxError at line:33(col:39)-34(col:1)
let &makeprg .= " 'e/^SyntaxError at line\\:(?<row>\\d+?)\\(col\\:(?<col>\\d+)/igms'"
