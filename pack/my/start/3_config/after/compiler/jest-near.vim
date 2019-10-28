let &makeprg = 'myjest'
" let &makeprg = 'jest'

let &errorformat  = '%f:%l:%c:%m'
finish

let &errorformat  = ''

let &errorformat .= '%E%\s%#● %.%#›\s%#%m,'
let &errorformat .= '%-C%.%#node_modules/%.%#,'
let &errorformat .= '%-C%.%#|%.%#,'
let &errorformat .= '%-C\s%#,'
let &errorformat .= '%Z%\s%#at %.%# (%f:%l:%c),'
let &errorformat .= '%+C\s%#%.%#,'

let &errorformat .= '%W\s%#%m (%f:%l:%c),%Z,'
let &errorformat .= '%-G%.%#,'
