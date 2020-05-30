let &errorformat  = 'errorformatregex:%f:%l:%c:%t:%m'

let &makeprg  = 'jest --useStderr --verbose' 

if g:testNearest
  let testNameRegex = '^\s*(it|test)\([`"''](.*)[`"'']' 
  let line = search('\v' . testNameRegex, 'bcn')
  let matches = matchlist(getline(line), '\v' . testNameRegex)
  let testName = matches[2]
  let testName = escape(testName, '-/\^$*+?.()|[]{}')
  let &makeprg .= ' --testNamePattern "' . testName . '"'
endif

let &makeprg .= ' % $* 2>&1'

" remove colors
let &makeprg .= ' \| sed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g"'

let &makeprg .= " \\| errorformatregex "
let &makeprg .= " 'e/^()\\s*(.+)\\:(\\d+)\\:(\\d+) .+$/gm'"
" let &makeprg .= " 'e/^\\s*()FAIL (\\S+)()().*$/gm'"
let &makeprg .= " 'i/^\\s*(at)\\s*.+?\\((node_modules.+?):(\\d+):(\\d+)\\)/gm'"
let &makeprg .= " 'e/^\\s*(at)\\s*.+?\\((.+?):(\\d+):(\\d+)\\)/gm'"
let &makeprg .= " 'i/()(\\S+)\\:(\\d+)/gm'"
