if exists("b:did_ftplugin_javascript")
    finish
endif
let b:did_ftplugin_javascript = 1

FormatterSet eslint-formatter

" http://eslint.org/docs/rules/
" stdin currently does not work with --fix
let g:formatters_javascript = ['eslint']
let g:formatdef_eslint = '"pipe-wrapper eslint --fix -c ~/.eslintrc-format.yml"'

let g:neomake_javascript_enabled_makers = ['eslint']

finish

let g:syntastic_javascript_checkers = ['eslint']
