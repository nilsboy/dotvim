let &errorformat  = 'errorformatregex:%f:%l:%c:%t:%m'

let line = search('\v^\s*it\(.*\)', 'bcn')
call nb#info('### jj137 getline(line): ', getline(line))
let matches = matchlist(getline(line), '\v^\s*it\([`"''](.*)[`"'']')
" call nb#info('### jj114 matches: ',  matches)
let testName = matches[1]
" let testName = shellescape(testName, 1)
echom "jjjjjjjj " . testName

let &makeprg  = 'jest --useStderr --verbose --testNamePattern "' 
      \ . testName . '" % 2>&1'
let &makeprg .= ' \| sed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g"'

let &makeprg .= " \\| errorformatregex "
let &makeprg .= " 'e/^()\\s*(.+)\\:(\\d+)\\:(\\d+) .+$/gm'"
" let &makeprg .= " 'e/^\\s*()FAIL (\\S+)()().*$/gm'"
let &makeprg .= " 'i/^\\s*(at)\\s*.+?\\((node_modules.+?):(\\d+):(\\d+)\\)/gm'"
let &makeprg .= " 'e/^\\s*(at)\\s*.+?\\((.+?):(\\d+):(\\d+)\\)/gm'"
let &makeprg .= " 'i/()(\\S+)\\:(\\d+)/gm'"

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
