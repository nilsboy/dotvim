let &errorformat  = 'errorformatregex:%f:%l:%c:%t:%m'

" let &makeprg  = 'jest --useStderr --verbose' 
let &makeprg  = 'jest --verbose' 

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
let &makeprg .= ' ' . expand('%:p') . ' $* 2>&1 '

" strip colors
" let &makeprg .= ' \| sed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g"'

let &makeprg .= " \\| errorformatregex"

let &makeprg .= " 'e/●.*?at .*?(?<file>\\S+?):(?<row>\\d+?):(?<col>\\d+)/igms'"
 " │       at src/services/resource-import-v1/resource-import-v1.class.js:95:17

let &makeprg .= " 'e/●.*?at .*?\\((?<file>\\S+?):(?<row>\\d+?):(?<col>\\d+)\\)/igms'"
" │       at Object.<anonymous> (test/services/resource-v1.test.js:276:10)

" let &makeprg .= " 'i/error/igm'"
" let &makeprg .= " 'w/warning/igm'"

" joi error locations:
" TODO: fine tune
let &makeprg .= " 'e/\\s+\\[\\d+\\]/igm'"

let &makeprg .= " 'e/No tests found/igm'"
let &makeprg .= " 'e/exiting with code 1/igm'"

" match any filename
" POSIX filename: [-_.A-Za-z0-9]
" let &makeprg .= " 'i/([^\\s\\:\\/\\(\"\\\\]+\\/[^\\s\\:\\(\"\\\\]+\\.\\w+)/igm'"

" filename and location
" let &makeprg .= " 'i/(?<file>[^\\s\\:\\/\\(\"\\\\]+\\/[^\\s\\:\\(\"\\\\]+\\.\\w+).*?(?<row>\\d+)\\:(?<col>\\d+)/igm'"

" TODO:
" exclude node_modules
" let &makeprg .= " 'd/node_modules/igm'"

" TODO:
" 549 |     if (!state) {
" let &makeprg .= " 'd/^\\s+\\d+/igm'"

