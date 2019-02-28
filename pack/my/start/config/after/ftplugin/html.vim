" see also: https://github.com/wooorm/rehype

nnoremap <silent> <buffer> <leader>es :silent call MyShrinkShrink({
      \ 'start': '\<style',
      \ 'end': '<\/style',
      \ 'filetype': 'css',
      \ 'beforeRestore': function("MyHtmlShrinkBeforeRestore"),
      \ })<cr>
nnoremap <silent> <buffer> <leader>ej :silent call MyShrinkShrink({
      \ 'start': '<script>',
      \ 'end': '<\/script>',
      \ 'filetype': 'javascript',
      \ 'beforeRestore': function("MyHtmlShrinkBeforeRestore"),
      \ })<cr>

if exists("b:did_ftplugin_html")
  finish
endif
let b:did_ftplugin_html = 1

" tidy breaks indentation of script and style tags if their content is not wrapped
" in newlines
" https://github.com/htacg/tidy-html5/issues/56
function! MyHtmlShrinkBeforeRestore() abort
  return
  normal ggO
  normal Go
endfunction

" Needs a package json / every option is a npm package
MyInstall posthtml !npm install -g posthtml-cli
let g:neoformat_enabled_html = [ 'posthtml' ]
let g:neoformat_html_posthtml = {
      \ 'exe': 'posthtmlwrapper'
      \ }

finish

" clean-html has all kinds of problems
" i.e. can't handle doctype tag, wrap seems to create a deep recursion.
MyInstall clean-html
let g:neoformat_enabled_html = ['clean_html']
let g:neoformat_html_clean_html = {
      \ 'exe': 'clean-html'
      \ ,'args': [ '--break-around-tags true', '--wrap 80' ]
      \ }

" Tidy does not currently support custom elements (2017-02-01):
" https://github.com/htacg/tidy-html5/issues/119
let g:neoformat_enabled_html = ['tidy']
let g:neoformat_html_tidy = {
      \ 'exe': 'tidy'
      \ ,'args': [ '-quiet -config ' . $CONTRIB_ETC . '/tidyrc-html']
      \ }

" incrementally indent html when using "="
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

" call OnSyntaxChange#Install('Javascript', 'javaScript' , 1, 'a')
" autocmd User SyntaxJavascriptEnterA let b:region_filetype = 'javascript'
" autocmd User SyntaxJavascriptLeaveA unlet! b:region_filetype

" call OnSyntaxChange#Install('Css', 'cssStyle' , 1, 'a')
" autocmd User SyntaxCssEnterA let b:region_filetype = 'css'
" autocmd User SyntaxCssLeaveA unlet! b:region_filetype

" html-beautify minimizes scripts or unevens indenting of the script tag itself
let g:neoformat_enabled_html = ['htmlbeautify']
let g:neoformat_html_htmlbeautify = {
      \ 'exe': 'html-beautify'
      \ ,'args': [ '
      \ -f - 
      \ --indent-size 2
      \ --wrap-line-length 80
      \ --preserve-newlines
      \ --max-preserve-newlines 1
      \ --indent-inner-html true
      \ --indent-scripts separate
      \ --unformatted script
      \ --unformatted style
      \ ']
      \ }

" Can not leave javscript alone - seems to have eslint option though
"
" The default javascript formatter joins these 2 lines:
" const fs = require(`fs`)
" this.is = `app-component`
"
" npm install -g prettydiff/prettydiff
" let g:neoformat_enabled_html = ['prettydiff']
MyInstall prettydiff npm install -g prettydiff/prettydiff
let g:neoformat_html_prettydiff = {
      \ 'exe': 'prettydiff',
      \ 'args': ['mode:"beautify"',
      \ 'lang:"html"',
      \ 'readmethod:"filescreen"',
      \ 'endquietly:"quiet"',
      \ 'source:"%:p"',
      \ 'styleguide:"none"'
      \ ],
      \ 'no_append': 1
      \ }

