let &errorformat  = 'errorformatregex:%f:%l:%c:%t:%m'

call writefile([expand('%:p')], "/tmp/haha")

let &makeprg  = 'jest --verbose --runInBand'
" --forceExit
" --detectOpenHandles
" --testTimeout
" --onlyChanged

if g:testNearest
  let testNameRegex = '^\s*(it|test)\([`"''](.*)[`"'']' 
  let line = search('\v' . testNameRegex, 'bcn')
  let matches = matchlist(getline(line), '\v' . testNameRegex)
  let testName = matches[2]
  let testName = escape(testName, '-/\^$*+?.()|[]{}')
  let &makeprg .= ' --testNamePattern "' . escape(testName, '"') . '$"'
endif

" need to use expand instead of % to be able to rerun a test
" let &makeprg .= ' % $* '
" let &makeprg .= ' ' . expand('%:p') . ' $* 2>&1'
let &makeprg .= ' $* 2>&1'

let &makeprg .= " \\| tee -a /tmp/haha"

let &makeprg .= " \\| grep -vF '(node_modules/'"
let &makeprg .= " \\| errorformatregex"

" at src/services/resource-import-v1/resource-import-v1.class.js:95:17
" let &makeprg .= " 'e/●.*?at .*?(?<file>\\S+?):(?<row>\\d+?):(?<col>\\d+)/igms'"

" at Object.<anonymous> (test/services/resource-v1.test.js:276:10)
let &makeprg .= " 'e/●.*?at .*?\\((?<file>\\S+?):(?<row>\\d+?):(?<col>\\d+)\\)/igms'"
" let &makeprg .= " 'e/●.*?at .*?\\((?<file>(?<!.*node_modules.*).+?):(?<row>\\d+?):(?<col>\\d+)\\)/igms'"

" Error: Caught unhandledRejection: 'Cannot use a session that has ended'
let &makeprg .= " 'e/.*Caught unhandledRejection.*/igms'"

" joi error locations:
" TODO: fine tune
let &makeprg .= " 'e/\\s+\\[\\d+\\]/igm'"

let &makeprg .= " 'e/No tests found/igm'"
let &makeprg .= " 'e/exiting with code 1/igm'"

" typescript
let &makeprg .= " 'e/(?<file>\\S+?):(?<row>\\d+?):(?<col>\\d+)\\s+\\-\\s+error\\s+TS\\d+/igms'"


" TODO:
" exclude node_modules
" let &makeprg .= " 'd/node_modules/igm'"

" TODO:
" 549 |     if (!state) {
" let &makeprg .= " 'd/^\\s+\\d+/igm'"

