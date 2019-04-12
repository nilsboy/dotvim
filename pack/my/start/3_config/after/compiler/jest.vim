let &makeprg = 'jest $*'
      " \ . ' 2>&1'
      " \ . ' \| perl -ne "print if ! /^\s+((>\s\d+\|\d+)\s\\|.+$\|\\|\s+\^$)/i"'
      " \ . ' \| perl -007 -pe "s/^FAIL.*//gms"'

" --testLocationInResults
" --useStderr

let &errorformat  = ''

" ignore empty lines
" let &errorformat .= '%C,'

" remove trailing stat lines etc.
let &errorformat .= '%-ATest Suites%.%#,'
let &errorformat .= '%C%.%#,'

" remove lines containing a pipe (source code output)
let &errorformat .= '%-G%.%#\|%.%#,'

let &errorformat .= '%-G%\s%#● %.%#,'
let &errorformat .= '%-G%.%#node_modules/%.%#,'

let &errorformat .= '     %m (%f:%l:%c),'

" let &errorformat .= '%-A,'
" let &errorformat .= '%Z,'

" let &errorformat = '%m'

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
