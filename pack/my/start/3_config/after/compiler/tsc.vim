let &errorformat  = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg  = 'tsc --project . --noemit'
let &makeprg .= ' 2>&1'

" let &makeprg .= " \\| grep -vFi 'node_modules/'"
let &makeprg .= " \\| errorformatregex"
" property.d.ts                │ node_modules/@lit/reactive-element/decorators/property.d.ts(6,15): error TS1005: ',' expected.

" foo/bar.ts(13,23): error TS1261: Already included...
let &makeprg .= " 'e/^(?<file>.+)\\((?<row>\\d+),(?<col>\\d+)\\).*$/igm'"

