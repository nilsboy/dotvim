" let &errorformat = g:MyJavascriptErrorformat

" let &makeprg = 'mocha --no-colors --full-trace --compilers js:babel-core/register'
" let &makeprg = 'mocha --full-trace --no-colors'
" let &makeprg = 'mocha --reporter tap $*'
let &makeprg = 'mocha $*'

" :set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

let &l:errorformat  = '%m'
" let &l:errorformat  = ''
" let &l:errorformat .= '%Enot ok %n %.%#,'
" let &l:errorformat .= '%Z\ %#at\ %f:%l:%c,'
" let &l:errorformat .= '%Z\ %#at\ %.%#\ (%f:%l:%c),'
" let &l:errorformat .= '%C\ %#%m,'
" let &l:errorformat .= '%-G%.%#,'

