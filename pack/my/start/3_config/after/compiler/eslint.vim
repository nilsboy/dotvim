" --no-eslintrc = only report es errors not formatting problems etc
let &l:makeprg='eslint -f unix --no-eslintrc %'

" " eslint can not format from stdin - only lint.
" " Errors are reported to stdout never to stderr. Specifying --quiet suppresses
" " them completely.
" " The result can not be send to stdout - the file is changed in place.
" let g:neoformat_javascript_eslint = {
"       \ 'exe': 'eslint'
"       \ ,'args': ['--fix', '--quiet', '-c'
"       \ , $CONTRIB . '/eslintrc-format.yml']
"       \ , 'replace': 1
"       \ }
" MyInstall eslint npm install -g eslint
