let &errorformat  = 'errorformatregex:%f:%l:%c:%t:%m'

" let &makeprg  = 'jest --useStderr --verbose' 
let &makeprg  = 'jest --verbose' 

if g:testNearest
  let testNameRegex = '^\s*(it|test)\([`"''](.*)[`"'']' 
  let line = search('\v' . testNameRegex, 'bcn')
  let matches = matchlist(getline(line), '\v' . testNameRegex)
  let testName = matches[2]
  let testName = escape(testName, '-/\^$*+?.()|[]{}')
  let &makeprg .= ' --testNamePattern "' . testName . '"'
endif

" need to use expand instead of % to be able to rerun a test
" let &makeprg .= ' % $* 2>&1'
let &makeprg .= ' ' . expand('%:p') . ' $* 2>&1'

" remove colors
let &makeprg .= ' \| sed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g"'

" TBD:
finish

let &makeprg .= " \\| errorformatregex"
let &makeprg .= " 'e/●/igm'"

" finish

" let &makeprg .= " 'e/error/igm'"
" let &makeprg .= " 'w/warning/igm'"

" joi error locations:
let &makeprg .= " 'e/\\[\\d+\\]/igm'"

" match any filename
" POSIX filename: [-_.A-Za-z0-9]
let &makeprg .= " 'i/([^\\s\\:\\/\\(\"\\\\]+\\/[^\\s\\:\\(\"\\\\]+\\.\\w+)/igm'"

" filename and location
let &makeprg .= " 'i/([^\\s\\:\\/\\(\"\\\\]+\\/[^\\s\\:\\(\"\\\\]+\\.\\w+).*?(\\d+)\\:(\\d+)/igm'"

" exclude node_modules
let &makeprg .= " 'd/node_modules/igm'"






