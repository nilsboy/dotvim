let &errorformat  = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg  = 'vite-node ' 

let &makeprg .= ' ' . expand('%:p') . ' $* 2>&1'

let &makeprg .= " \\| errorformatregex"

" foot/bar.ts(17,5): error TS2322: ...
let &makeprg .= " 'e/^(?<file>\\S+?)\\((?<row>\\d+?),(?<col>\\d+)\\):\\s+error\\s+TS\\d+.+$/igms'"

" at MySqlExceptionConverter.convertException (node_modules/@mikro-orm/core/platforms/ExceptionConverter.js:8:16)
let &makeprg .= " 'e/^\\s+at\\s+.+?\\s\\((?<file>[^:\\s]+?):(?<row>\\d+?):(?<col>\\d+)\\)$/igms'"

" /foo/bar:258
let &makeprg .= " 'e/^(?<file>[^:\\s]+?):(?<row>\\d+?)$/igms'"

