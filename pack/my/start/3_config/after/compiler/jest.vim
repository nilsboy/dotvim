let &makeprg = 'jest $*'
      " \ . ' 2>&1'
      " \ . ' \| perl -ne "print if ! /^\s+((>\s\d+\|\d+)\s\\|.+$\|\\|\s+\^$)/i"'
      " \ . ' \| perl -007 -pe "s/^FAIL.*//gms"'

" --testLocationInResults
" --useStderr

let &errorformat  = ''

" ignore empty lines
let &errorformat .= '%C,'

" ignore all lines containing a pipe (source code output) - this can not be
" prefiltered with a %-G!
let &errorformat .= '%-G%.%#\|%.%#,'

" let &errorformat .= '%C%.%#\|%.%#,'
" let &errorformat .= '%C%.%#node_modules%.%#,'

" let &errorformat .= '%Aerror:%\s%#%m,'
" let &errorformat .= '%A%\s%#%\w%\+error:%*[ ]%m,'
" let &errorformat .= '%A%m,'
" let &errorformat .= '%Z%\s%#at %.%# (%f:%l:%c),'
" let &errorformat .= '%Z%\s%#at %f:%l:%c,'

" let &errorformat .= '%A%\s%#console.%.%#,'
" let &errorformat .= '%Z%\s%#%f:%l:%c:%m,'

let &errorformat .= '%\s%#console.%\w%\+ %f:%l,'

let &errorformat .= '%A%\s%#● %.%#,'
let &errorformat .= '%Z%\s%#at %.%# (%f:%l:%c),'
let &errorformat .= '%Z%\s%#at %f:%l:%c,'
" let &errorformat .= '%C%\s%#%m,'

let &errorformat .= '%\s%#at %.%# (%f:%l:%c),'
let &errorformat .= '%\s%#at %f:%l:%c,'

finish
  ● not a valid error

  ● 'resource' service › create esim

    Timeout - Async callback was not invoked within the 5000ms timeout specified by jest.setTimeout.

      19 |   })
      20 | 
    > 21 |   test(`create esim`, async() => {
         |   ^
      22 |     const fixture = require(`../fixture/esim`)
      23 |     await service.create(fixture.db)
      24 |   })

      at new Spec (node_modules/jest-jasmine2/build/jasmine/Spec.js:85:20)
      at Suite.test (test/services/resource.test.js:21:3)
      at Object.describe (test/services/resource.test.js:4:1)

  console.log test/services/resource.test.js:8
  ### HERE8 foo
