" FormatterSet eslint-formatter
" TODO: add?: https://github.com/lebab/lebab
" TODO: checkout jsctags generator using tern
" (https://github.com/ramitos/jsctags)

" Get source of core node modules: process.binding("natives").assert

" support module filenames
setlocal iskeyword+=-

setlocal suffixesadd=.js,.node,.json
let &l:include = '\v<(require\([''"]|from\s+[''"])'
let &l:define = '\v(class|[:=]\s+function|Object\.defineProperty|\.prototype\.|^\s*const\s+|async\s|\s\w+\(.+\{|module\.exports|^\s*let\s*)'
let b:outline = '(^\s*class\s*.+\{|^\s*(async)*\s*function\s+.+\{|^\s*(test|id)\s*\(.+\{|^\s*(static)*\s*(async)*\s*\w+\s*\(.+\{|^[\w\.]+\s*\=)'
" let b:outline = '^\s*(?!if)\s*(static)*\s*(async)*\s*\w+\s*\(.+\{'
" const deactivateBundleItem = async(item) => {
let b:outline = '^((?!\s*(if|for|while))\s*(\b(async|static)\b)*\s*\w+\s*\(.+\{$|\s*class\s+\w+\b|[\w\.]+\s*=)'

setlocal path+=node_modules,~/src/node/lib

" This does what &include by itself should do - but still works a lot
" better!?!
function! MyJavascriptIncluedExpr() abort
  let wanted = v:fname
  for dir in split(&path, ',')
    for suffix in split(&suffixesadd, ',')
      let file = dir . '/' . wanted . suffix
      if filereadable(file)
        return file
      endif
    endfor
  endfor
  return wanted
endfunction
set includeexpr=MyJavascriptIncluedExpr()

" setlocal omnifunc=lsp#omni#complete

nnoremap <buffer> <silent><leader>lI yi`:execute 'terminal npm install ' . @"<cr>

" edit module documention
nnoremap <buffer> <silent> <leader>lmm yi`:execute 'edit ./node_modules/' . @" . '/README.md'<cr>
nnoremap <buffer> <silent> <leader>lmi :call MyQuickfixSearch({
      \ 'path':  FindRootDirectory() . '/node_modules/',
      \ 'term': input('Module name: '),
      \ 'grep': 0,
      \ })<cr>
nnoremap <buffer> <silent> <leader>lmw yi`:call MyQuickfixSearch({
      \ 'path':  FindRootDirectory() . '/node_modules/',
      \ 'term': @",
      \ 'grep': 0,
      \ })<cr>

if exists("b:MyJavascriptFtpluginLoaded")
  finish
endif
let b:MyJavascriptFtpluginLoaded = 1

" from vim-nodejs-errorformat: Error: bar at Object.foo [as _onTimeout]
" (/Users/Felix/.vim/bundle/vim-nodejs-errorformat/test.js:2:9)
let g:MyJavascriptErrorformat  = '%AError: %m' . ','
let g:MyJavascriptErrorformat .= '%AEvalError: %m' . ','
let g:MyJavascriptErrorformat .= '%ARangeError: %m' . ','
let g:MyJavascriptErrorformat .= '%AReferenceError: %m' . ','
let g:MyJavascriptErrorformat .= '%ASyntaxError: %m' . ','
let g:MyJavascriptErrorformat .= '%ATypeError: %m' . ','
let g:MyJavascriptErrorformat .= '%Z%*[ ]at %f:%l:%c' . ','
let g:MyJavascriptErrorformat .= '%Z%*[ ]%m (%f:%l:%c)' . ','

"     at Object.foo [as _onTimeout] (/Users/Felix/.vim/bundle/vim-nodejs-errorformat/test.js:2:9)
let g:MyJavascriptErrorformat .= '%*[ ]%m (%f:%l:%c)' . ','

"     at node.js:903:3
let g:MyJavascriptErrorformat .= '%*[ ]at %f:%l:%c' . ','

" /Users/Felix/.vim/bundle/vim-nodejs-errorformat/test.js:2
"   throw new Error('bar');
"         ^
let g:MyJavascriptErrorformat .= '%Z%p^,%A%f:%l,%C%m' . ','
let g:MyJavascriptErrorformat .= '%f:%l:%c:%m,'

" Ignore everything else
" let g:MyJavascriptErrorformat .= '%-G%.%#,'

let g:neomake_run_maker = {
      \ 'exe': 'node',
      \ 'args': ['--harmony', '%:p'],
      \ 'errorformat': '%m',
      \ 'output_stream': 'both',
      \ }
" \ 'errorformat': g:MyJavascriptErrorformat,
" \ 'postprocess':
" function('MyJavascriptFixCoreFileLocationInQuickfix')

let test#runners = {'JavaScript': ["Jest", "Mocha", "Intern", "TAP",
      \ "Karma", "Lab", "Jasmine"] }

"### Linter

let g:ale_javascript_eslint_options = ' -c ' . $CONTRIB . '/eslintrc.json'
" let g:ale_linters['javascript'] = ['flow']
" let g:ale_linters['javascript'] = ['eslint']
" " let g:ale_javascript_eslint_executable = 'babel-eslint'
" " let g:ale_javascript_eslint_use_global = 1

"### Formatter

" eslint can not format from stdin - only lint.
" Errors are reported to stdout never to stderr. Specifying --quiet suppresses
" them completely.
" The result can not be send to stdout - the file is changed in place.
let g:neoformat_javascript_eslint = {
      \ 'exe': 'eslint'
      \ ,'args': ['--fix', '--quiet', '-c'
      \ , $CONTRIB . '/eslintrc-format.yml']
      \ , 'replace': 1
      \ }
MyInstall eslint !npm install -g eslint

MyInstall prettier !npm install -g prettier prettier-eslint-cli
" let g:neoformat_enabled_javascript = [ 'prettier' ]
let g:neoformat_javascript_prettier = {
      \ 'exe': 'prettier'
      \ ,'args': ['--no-semi', '--single-quote']
      \ }

" let g:neoformat_enabled_javascript = [ 'prettier_eslint' ]
let g:neoformat_javascript_prettier_eslint = {
      \ 'exe': 'prettier-eslint'
      \ }
" \ ,'args': ['--log-level', 'error']

let g:neoformat_enabled_javascript = [ 'my_formatter' ]
let g:neoformat_javascript_my_formatter = {
      \ 'exe': 'my_javascript_formatter'
      \ }

nnoremap <silent> <leader>cp :call MyJavascriptConvertFromPerl()<cr>
function! MyJavascriptConvertFromPerl()
  %s/sub //g
  %s/my /let /g
  %s/\$//g
  %s/method //g
  %s/self/this/g
  %s/->/./g
  %s/=>/:/g
  %s/die /throw(/g
  %s/\:\://g
  %s/^\s*#/\/\//g
endfunction
