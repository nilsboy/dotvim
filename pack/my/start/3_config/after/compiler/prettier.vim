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

" foot/bar.ts(17,5): error TS2322: ...
let &makeprg .= " 'e/^(?<file>\\S+?)\\((?<row>\\d+?),(?<col>\\d+)\\):\\s+error\\s+TS\\d+.+$/igms'"

" at MySqlExceptionConverter.convertException (node_modules/@mikro-orm/core/platforms/ExceptionConverter.js:8:16)
let &makeprg .= " 'e/^\\s+at\\s+.+?\\s\\((?<file>[^:\\s]+?):(?<row>\\d+?):(?<col>\\d+)\\)$/igms'"

" /foo/bar:258
let &makeprg .= " 'e/^(?<file>[^:\\s]+?):(?<row>\\d+?)$/igms'"

" │ [error] doc/queries.mongodb.js: SyntaxError: Missing semicolon. (1:3)
let &makeprg .= " 'e/\\[error\\]\\s+(?<file>.+)?\\:.+?\\((?<row>\\d+)\\:(?<col>\\d+)\\)$/igms'"

" TODO:
" exclude node_modules
" let &makeprg .= " 'd/node_modules/igm'"

