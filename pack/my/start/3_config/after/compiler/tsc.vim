let &errorformat  = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg  = 'tsc --project . --noemit'
let &makeprg .= ' 2>&1'

let &makeprg .= " \\| errorformatregex"

" foo/bar.ts(13,23): error TS1261: Already included...
let &makeprg .= " 'e/^(?<file>.+)\\((?<row>\\d+),(?<col>\\d+)\\).*$/igm'"

