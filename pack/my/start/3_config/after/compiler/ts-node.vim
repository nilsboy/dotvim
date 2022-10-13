let &errorformat  = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg  = 'ts-node' 

let &makeprg .= ' ' . expand('%:p') . ' $* 2>&1'

let &makeprg .= " \\| errorformatregex"

" typescript
" let &makeprg .= " 'e/(?<file>\\S+?):(?<row>\\d+?):(?<col>\\d+)\\s+\\-\\s+error\\s+TS\\d+/igms'"

" src/foo.ts(17,5): error TS2322: ...
let &makeprg .= " 'e/^(?<file>\\S+?)\\((?<row>\\d+?),(?<col>\\d+)\\):\\s+error\\s+TS\\d+.+$/igms'"

" at MySqlExceptionConverter.convertException (node_modules/@mikro-orm/core/platforms/ExceptionConverter.js:8:16)
let &makeprg .= " 'e/^\\s+at\\s+.+?\\s\\((?<file>[^:\\s]+?):(?<row>\\d+?):(?<col>\\d+)\\)$/igms'"

" TODO:
" exclude node_modules
" let &makeprg .= " 'd/node_modules/igm'"

