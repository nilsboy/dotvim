if exists("b:did_ftplugin_javascript")
    finish
endif
let b:did_ftplugin_javascript = 1

setlocal tabstop=2
setlocal shiftwidth=2

" http://eslint.org/docs/rules/
" stdin currently does not work with --fix
let g:formatters_javascript = ['eslint']
let g:formatdef_eslint = '"pipe-wrapper eslint --fix"'

let g:neomake_javascript_enabled_makers = ['eslint']

" set makeprg=npm\ test

finish

let g:syntastic_javascript_checkers = ['eslint']
