let &makeprg = 'myjest'
" let &makeprg = 'jest'

let &errorformat  = 'errorformatregex:%f:%l:%c:%t:%m'

finish

" " remove lines containing a pipe (source code output)
" let &errorformat .= '%-G%.%#\|%.%#,'

" let &errorformat .= '%-G%\s%#● %.%#,'
" let &errorformat .= '%-G%.%#node_modules/%.%#,'
" let &errorformat .= '%-G%.%#○ skipped%.%#,'
" let &errorformat .= '%-G%.%##### Using database%.%#,'

" let &errorformat .= '%\s%#%m (%f:%l:%c),'

" let &errorformat = substitute(&errorformat, '\v,$', '', '')

let &errorformat .= '%E%\s%#● %.%#›\s%#%m,'
let &errorformat .= '%-C%.%#node_modules/%.%#,'
let &errorformat .= '%-C%.%#|%.%#,'
let &errorformat .= '%-C\s%#,'
let &errorformat .= '%Z%\s%#at %.%# (%f:%l:%c),'
let &errorformat .= '%+C\s%#%.%#,'

" let &errorformat .= '%-G%.%#,'
" let &errorformat = '%m,'

finish
  console.log node_modules/database.js:19
    #### Using database on host: undefined

      at Other.Class (otherfile:66:13)

 FAIL  test/services/resource-v1.test.js
  'resource' service
    ✕ create bundle (425ms)
    ○ skipped 15 tests

  ● 'resource' service › error1

    Error1

      77 |     if (e.isJoi) {
    > 78 |       throw new errors.BadRequest(e.details)
         |             ^
      79 |     } else {
      80 | 
      81 | 

      at new BadRequest (node_modules/@feathersjs/errors/lib/index.js:86:17)
      at Object.validate (file1:78:13)

  ● 'resource' service › error2

    Error2

      77 |     if (e.isJoi) {
    > 78 |       throw new errors.BadRequest(e.details)
         |             ^
      79 |     } else {
      80 | 
      81 | 

      at new BadRequest (node_modules/@feathersjs/errors/lib/index.js:86:17)
      at Object.validate (file2:79:13)

Test Suites: 1 failed, 1 total
Tests:       1 failed, 15 skipped, 16 total
Snapshots:   0 total
Time:        2.342s
Ran all test suites matching /test\/services\/resource-v1.test.js/i with tests matching "^'resource' service create bundle$".
debug: error app.service('v1/resources').create()
error: BadRequest: Error
    at Object.validate (otherfile2:78:13)
    at <anonymous>
