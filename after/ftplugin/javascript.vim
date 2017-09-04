" FormatterSet eslint-formatter
" TODO: add?: https://github.com/lebab/lebab
" TODO: checkout husky:
" (see https://github.com/prettier/prettier)
" TODO: checkout formatter: https://www.npmjs.com/package/prettier-in-html
" TODO: checkout jsctags generator using tern
" (https://github.com/ramitos/jsctags)

if exists("b:MyJavascriptFtpluginLoaded")
    finish
endif
let b:MyJavascriptFtpluginLoaded = 1

nnoremap <buffer> <leader>lI :terminal npm install<cr>
nnoremap <buffer> <leader>li yi":execute ':terminal npm install --save '
      \ . @"<cr>

augroup MyJavascriptAugroupAddTypeMarker
  autocmd!
  autocmd BufLeave <buffer> normal! mJ
augroup END

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

" Ignore everything else
" let g:MyJavascriptErrorformat .= '%-G%.%#,'

let g:neomake_run_maker = {
    \ 'exe': 'babel-node',
    \ 'args': ['%:p'],
    \ 'errorformat': g:MyJavascriptErrorformat,
    \ 'output_stream': 'both',
    \ }
    " \ 'postprocess':
    " function('MyJavascriptFixCoreFileLocationInQuickfix')

" TODO
function! MyJavascriptFixCoreFileLocationInQuickfix(entry) abort
  let filename = bufname(i.bufnr)
  " Non-existing file in the quickfix list, assume a core file
  if filereadable(filename)
    return
  endif
  " Load the node.js core file (thanks @izs for pointing this out!)
  silent! execute 'read !node -e "console.log(process.binding(\"natives\").' expand('%:r') ')"'
  " Delete the first line, always empty for some reason
  execute ':1d'
endfunction

"### Linter

let g:ale_javascript_eslint_options = ' -c ' . g:vim.contrib.etc.dir . 'eslintrc.json'
let g:ale_linters['javascript'] = ['eslint']
" let g:ale_javascript_eslint_executable = 'babel-eslint'
" let g:ale_javascript_eslint_use_global = 1

"### Formatter

" augroup MyJavascriptAugroupAutoformat
"   autocmd!
"   " autocmd InsertLeave <buffer> :Neoformat
"   " autocmd CursorHold <buffer> :Neoformat
"   " autocmd TextChanged,InsertLeave <buffer> :Neoformat
" augroup END

" alternative javascript formatters:
" - https://github.com/prettydiff/prettydiff

" eslint can not format from stdin - only lint.
" Errors are reported to stdout never to stderr. Specifying --quiet suppresses
" them completely.
" The result can not be send to stdout - the file is changed in place.
let g:neoformat_javascript_eslint = {
      \ 'exe': 'eslint'
      \ ,'args': ['--fix', '--quiet', '-c'
      \ , g:vim.contrib.etc.dir . 'eslintrc-format.yml']
      \ , 'replace': 1
      \ }

" let g:neoformat_javascript_eswraplines = {
"       \ 'exe': 'es-wrap-lines'
"       \ }

" let g:neoformat_enabled_javascript = [ 'eslint',  'eswraplines']

" npm install -g prettier
" let g:neoformat_enabled_javascript = [ 'prettier' ]
let g:neoformat_javascript_prettier = {
      \ 'exe': 'prettier'
      \ ,'args': ['--no-semi', '--single-quote']
      \ }

" npm install -g prettier-eslint-cli
" let g:neoformat_enabled_javascript = [ 'prettier_eslint' ]
let g:neoformat_javascript_prettier_eslint = {
      \ 'exe': 'prettier-eslint'
      \ }
      " \ ,'args': ['--log-level', 'error']

let g:neoformat_enabled_javascript = [ 'my_formatter' ]
let g:neoformat_javascript_my_formatter = {
      \ 'exe': g:vim.contrib.bin.dir . 'my_javascript_formatter'
      \ }

" https://www.reddit.com/r/vim/comments/65vnrq/coworkers_criticize_my_workflow_for_lacking/dgdm8vj/?st=j1ndnrm3&sh=5b3bc21a
setlocal suffixesadd+=.js
setlocal include=^\\s*[^\/]\\+\\(from\\\|require(['\"]\\)
setlocal define=^\\s*[^/,\\":=]*\\s*[:=]*\\s*\\(class\\\|function\\\|define\\\|export\\s\\(default\\)*\\)[('\"]\\{-\\}

" let g:syntastic_javascript_checkers = ['eslint']

" " http://eslint.org/docs/rules/
" " stdin currently does not work with --fix
" let g:formatters_javascript = ['eslint']
" let g:formatdef_eslint = '"pipe-wrapper eslint --fix -c ~/.eslintrc-format.yml"'

" let g:neomake_javascript_enabled_makers = ['eslint']

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
