let &errorformat  = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg  = 'vitest --run'
" let &makeprg  = 'vitest --run --reporter=./rep.ts'

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

let &makeprg .= " \\| tee " . g:nb#runlogfile

let &makeprg .= " \\| grep -vF 'node_modules/'"
let &makeprg .= " \\| errorformatregex"

" FAIL  test/src/OrderItemContext.test.ts [ test/src/OrderItemContext.test.ts ]
let &makeprg .= " 'e/^\\s+FAIL\\s+.+?\\\[\\s+(?<file>\\S+)\\s+\\\]$/igms'"

" FAIL  test/src/OrderItemContext.test.ts
let &makeprg .= " 'e/^\\s+FAIL\\s+(?<file>\\S+)\\s*$/igms'"

" " FAIL  test/src/OrderItemContext.test.ts > OrderItemContext
" " ❯ ProductSpecificationContext.build src/ProductSpecificationContext.ts:11:72
" " ❯ ProductContext.build src/ProductContext.ts:30:37
let &makeprg .= " 'e/^\\s+FAIL\\s+.+❯\\s+(?<file>\\S+?):(?<row>\\d+?):(?<col>\\d+)\\n\\n/igms'"

" " Error: Caught unhandledRejection: 'Cannot use a session that has ended'
" let &makeprg .= " 'e/.*Caught unhandledRejection.*/igms'"

" " joi error locations:
" " TODO: fine tune
" let &makeprg .= " 'e/\\s+\\[\\d+\\]/igm'"

" let &makeprg .= " 'e/No tests found/igm'"
" let &makeprg .= " 'e/exiting with code 1/igm'"

" " typescript
" let &makeprg .= " 'e/(?<file>\\S+?):(?<row>\\d+?):(?<col>\\d+)\\s+\\-\\s+error\\s+TS\\d+/igms'"

" typescript
" TypeError: Cannot read properties of undefined (reading 'productSpecCharacteristic')
"  ❯ CharacteristicsContext.generateDefaultCharacteristicsFromSpec src/CharacteristicsContext.ts:42:33
let &makeprg .= " 'e/^\\w+Error\\:.+?\\ (?<file>\\S+?):(?<row>\\d+?):(?<col>\\d+)$/igms'"
