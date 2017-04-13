" FormatterSet eslint-formatter
" TODO: add?: https://github.com/lebab/lebab

nnoremap <buffer> <leader>lI :terminal npm install<cr>
nnoremap <buffer> <leader>li yi`:execute ':terminal npm install --save '
      \ . @"<cr>

if exists("b:did_ftplugin_javascript")
    finish
endif
let b:did_ftplugin_javascript = 1

augroup ftplugin_javascript
  autocmd!
  autocmd BufLeave *.js normal! mJ
augroup END

"### Linter

let g:ale_javascript_eslint_options = ' -c ' . g:vim.etc.dir . '/contrib/eslintrc.yml'
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
      \ g:vim.etc.dir . '/contrib/eslintrc-format.yml']
      \ , 'replace': 1
      \ }

let g:neoformat_javascript_eswraplines = {
      \ 'exe': 'es-wrap-lines'
      \ }

let g:neoformat_enabled_javascript = [ 'eslint',  'eswraplines']

" nnoremap <silent> <buffer> <leader>x
"   \ :Neoformat eslint
"   \ <cr>
  " \  \| :Neoformat eswraplines

finish

let g:syntastic_javascript_checkers = ['eslint']

" http://eslint.org/docs/rules/
" stdin currently does not work with --fix
let g:formatters_javascript = ['eslint']
let g:formatdef_eslint = '"pipe-wrapper eslint --fix -c ~/.eslintrc-format.yml"'

let g:neomake_javascript_enabled_makers = ['eslint']
