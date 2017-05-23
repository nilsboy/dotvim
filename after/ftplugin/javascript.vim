" FormatterSet eslint-formatter
" TODO: add?: https://github.com/lebab/lebab
" TODO: checkout husky:
" (see https://github.com/prettier/prettier)
" TODO: checkout formatter: https://www.npmjs.com/package/prettier-in-html
" TODO: errorformat

let &l:makeprg = 'node %'

nnoremap <buffer> <leader>lI :terminal npm install<cr>
nnoremap <buffer> <leader>li yi`:execute ':terminal npm install --save '
      \ . @"<cr>

if exists("b:did_ftplugin_javascript")
    finish
endif
let b:did_ftplugin_javascript = 1

augroup ftplugin_javascript
  autocmd!
  autocmd BufLeave <buffer> normal! mJ
  " autocmd InsertLeave <buffer> :Neoformat
  " autocmd CursorHold <buffer> :Neoformat
  " autocmd TextChanged,InsertLeave <buffer> :Neoformat
augroup END

" let g:neomake_javascript_run_maker = {
let g:neomake_run_maker = {
    \ 'exe': 'node',
    \ 'args': ['%:p'],
    \ 'errorformat': '%AError: %m,%AEvalError: %m,%ARangeError: %m,%AReferenceError: %m,%ASyntaxError: %m,%ATypeError: %m,%Z%*[\ ]at\ %f:%l:%c,%Z%*[\ ]%m (%f:%l:%c),%*[\ ]%m (%f:%l:%c),%*[\ ]at\ %f:%l:%c,%Z%p^,%A%f:%l,%C%m,%-G%.%#'
    \ }

"### Linter

let g:ale_javascript_eslint_options = ' -c ' . g:vim.contrib.etc.dir . 'eslintrc.json'
let g:ale_linters['javascript'] = ['eslint']

"### Formatter

" alternative javascript formatters:
" - https://github.com/prettydiff/prettydiff

" eslint can not format from stdin - only lint.
" Errors are reported to stdout never to stderr. Specifying --quiet suppresses
" them completely.
" The result can not be send to stdout - the file is changed in place.
let g:neoformat_javascript_eslint = {
      \ 'exe': 'eslint'
      \ ,'args': ['--fix', '--quiet', '-c',
      \ g:vim.contrib.etc.dir . 'eslintrc-format.yml']
      \ , 'replace': 1
      \ }

let g:neoformat_javascript_eswraplines = {
      \ 'exe': 'es-wrap-lines'
      \ }

" let g:neoformat_enabled_javascript = [ 'eslint',  'eswraplines']

" npm install -g prettier
let g:neoformat_enabled_javascript = [ 'prettier' ]
let g:neoformat_javascript_prettier = {
      \ 'exe': 'prettier'
      \ ,'args': ['--no-semi', '--single-quote']
      \ }

" npm install -g prettier-eslint-cli
let g:neoformat_enabled_javascript = [ 'prettier_eslint' ]
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

finish " #######################################################################

let g:syntastic_javascript_checkers = ['eslint']

" http://eslint.org/docs/rules/
" stdin currently does not work with --fix
let g:formatters_javascript = ['eslint']
let g:formatdef_eslint = '"pipe-wrapper eslint --fix -c ~/.eslintrc-format.yml"'

let g:neomake_javascript_enabled_makers = ['eslint']
