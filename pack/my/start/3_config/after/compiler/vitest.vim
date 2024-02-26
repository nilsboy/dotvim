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
let &makeprg = "( echo 'Running        : " . &makeprg . "'; echo 'Original Output: " . g:nb#tempdir . "vitest-compiler' ; " . &makeprg . " )"

let &makeprg .= " \\| tee --output-error=exit " . g:nb#tempdir . 'vitest-compiler'
let &makeprg .= " \\| grep -vi 'node\\:[^:]\\+'"
let &makeprg .= " \\| grep -vFi 'node_modules/'"
let &makeprg .= " \\| grep -vFi 'process.stdout.write'"
let &makeprg .= " \\| grep -vFi 'consoleWithStackTrace'"

let &makeprg .= " \\| errorformatregex"

" Error: Caught unhandledRejection: 'Cannot use a session that has ended'
" let &makeprg .= " 'e/.*Caught unhandledRejection.*/igms'"

" " joi error locations:
" " TODO: fine tune
" let &makeprg .= " 'e/\\s+\\[\\d+\\]/igm'"

" let &makeprg .= " 'e/No tests found/igm'"
" let &makeprg .= " 'e/exiting with code 1/igm'"
let &makeprg .= " 'e/error/igm'"

" ❯ Function.verifyViaDns src/DomainVerification.ts:21:15
" let &makeprg .= " 'e/\\s+(?<file>\\S+\\.\\S+?):(?<row>\\d+?):(?<col>\\d+)/igms'"
" let &makeprg .= " 'e/(?<file>[\\w\\/\\-\\.]+?):(?<row>\\d+?):(?<col>\\d+)/igms'"
let &makeprg .= " 'e/(?<file>[\\w\\/\\-\\.]+?):(?<row>\\d+?):(?<col>\\d+)/igms'"

" let &makeprg .= " 'e/(?<file>\\S+?):(?<row>\\d+?):(?<col>\\d+)\\s+\\-\\s+error\\s+TS\\d+/igms'"

" TypeError: Cannot read properties of undefined (reading 'productSpecCharacteristic')
"  ❯ CharacteristicsContext.generateDefaultCharacteristicsFromSpec src/CharacteristicsContext.ts:42:33
" let &makeprg .= " 'e/^\\w+Error\\:.+?\\ (?<file>\\S+?):(?<row>\\d+?):(?<col>\\d+)$/igms'"

" FAIL  test/src/ScannerNotification.test.ts ...
" let &makeprg .= " 'e/^\\s+FAIL\\s+(?<file>\\S+)\\s+/igms'"
" let &makeprg .= " 'e/^\\s+FAIL\\s+\\S+\\s+/igms'"
let &makeprg .= " 'r/^\s+FAIL\s+(?<file>\S+)\s+.+?\>\s+(?<location>.+)\s*$/igm'"

" │  FAIL  test/src/session-helper.test.ts > session-helper > generateMongoCustomerAccessConstraint CUSTOMER_ADMIN
