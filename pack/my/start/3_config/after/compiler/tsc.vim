let &errorformat  = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg  = 'tsc'
" let &makeprg  = 'cat ha'
let &makeprg .= ' 2>&1'

let &makeprg .= " \\| errorformatregex"

" src/my-product-list.ts(13,23): error TS1261: Already included...
let &makeprg .= " 'e/^(?<file>.+)\\((?<row>\\d+),(?<col>\\d+)\\).*$/igm'"

