" let &makeprg = 'myjest'
let &makeprg = 'jest'

" --testLocationInResults
" --useStderr

let &errorformat  = ''

" " remove trailing stat lines etc.
" let &errorformat .= '%-ATest Suites%.%#,'
" let &errorformat .= '%C%.%#,'

" remove lines containing a pipe (source code output)
let &errorformat .= '%-G%.%#\|%.%#,'

let &errorformat .= '%-G%\s%#● %.%#,'
" let &errorformat .= '%-G%.%#node_modules/%.%#,'
let &errorformat .= '%-G%.%#○ skipped%.%#,'
let &errorformat .= '%-G%.%##### Using database%.%#,'

let &errorformat .= '%\s%#%m (%f:%l:%c),'

" let &errorformat  = ''
" let &errorformat .= '%E%\s%#FAIL %f,'
" let &errorformat .= '%C\s%#,'
" let &errorformat .= '%C%m,'
" let &errorformat .= '%C%\s%#●,'
" let &errorformat .= '%Z%m,'

" let &errorformat .= '%C%\s%#> %l,'
" let &errorformat .= '%Z%\s%#|%p^,'

" let &errorformat  = '%f:%l:%c:%m'

let &errorformat = substitute(&errorformat, '\v,$', '', '')

" let &errorformat  = '%m'

finish
  console.log node_modules/database.js:19
    #### Using database on host: undefined

 FAIL  test/services/resource-v1.test.js
  'resource' service
    ✕ create bundle (425ms)
    ○ skipped 15 tests

  ● 'resource' service › create bundle

    BadRequest: Error

      77 |     if (e.isJoi) {
    > 78 |       throw new errors.BadRequest(e.details)
         |             ^
      79 |     } else {
      80 | 
      81 | 

      at new BadRequest (node_modules/@feathersjs/errors/lib/index.js:86:17)
      at Object.validate (src/services/resource-v1/resource-v1.hooks.js:78:13)

Test Suites: 1 failed, 1 total
Tests:       1 failed, 15 skipped, 16 total
Snapshots:   0 total
Time:        2.342s
Ran all test suites matching /test\/services\/resource-v1.test.js/i with tests matching "^'resource' service create bundle$".
debug: error app.service('v1/resources').create()
error: BadRequest: Error
    at Object.validate (src/services/resource-v1/resource-v1.hooks.js:78:13)
    at <anonymous>
