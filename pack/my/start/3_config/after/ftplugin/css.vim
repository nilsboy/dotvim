" see also:
" https://stylelint.io/
" https://github.com/morishitter/stylefmt

if exists("b:did_ftplugin_css")
  finish
endif
let b:did_ftplugin_css = 1

" MyInstall csscomb
" let g:neoformat_enabled_css = [ 'csscomb' ]
" let g:neoformat_css_csscomb = {
"       \ 'exe': 'csscomb',
"       \ 'args': ['-c ' . $CONTRIB . '/csscombrc'],
"       \ 'replace': 1
"       \ }

" MyInstall csslint
" let g:ale_linters['css'] = ['mycsslint']
" call ale#linter#Define('css', {
"       \ 'name': 'mycsslint',
"       \ 'executable': 'csslint',
"       \ 'command': g:ale#util#stdin_wrapper . 
"       \ ' .css csslint --format=compact --ignore=important,universal-selector,empty-rules,regex-selectors',
"       \ 'callback': 'ale#handlers#HandleCSSLintFormat',
"       \})

