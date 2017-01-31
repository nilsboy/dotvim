nnoremap <silent> <buffer> <leader>es :silent call shrink#shrink({
      \ 'start': '\<style',
      \ 'end': '<\/style',
      \ 'filetype': 'css',
      \ 'beforeRestore': function("ShrinkBeforeRestore"),
      \ })<cr>
nnoremap <silent> <buffer> <leader>ej :silent call shrink#shrink({
      \ 'start': '<script>',
      \ 'end': '<\/script>',
      \ 'filetype': 'javascript',
      \ 'beforeRestore': function("ShrinkBeforeRestore"),
      \ })<cr>

if exists("b:did_ftplugin_html")
  finish
endif
let b:did_ftplugin_html = 1

" tidy break indentation of script and style tags if their content is not wrapped
" in newlines
" https://github.com/htacg/tidy-html5/issues/56
function! ShrinkBeforeRestore() abort
  normal ggO
  normal Go
endfunction

let g:neoformat_enabled_html = ['tidy']
let g:neoformat_html_tidy = {
      \ 'exe': 'tidy'
      \ ,'args': [ '-quiet -config ' . g:vim.contrib.dir . 'tidyrc-html']
      \ }

finish

" incrementally indent html when using "="
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

" call OnSyntaxChange#Install('Javascript', 'javaScript' , 1, 'a')
" autocmd User SyntaxJavascriptEnterA let b:region_filetype = 'javascript'
" autocmd User SyntaxJavascriptLeaveA unlet! b:region_filetype

" call OnSyntaxChange#Install('Css', 'cssStyle' , 1, 'a')
" autocmd User SyntaxCssEnterA let b:region_filetype = 'css'
" autocmd User SyntaxCssLeaveA unlet! b:region_filetype

" TODO test:
" https://www.npmjs.com/package/clean-html

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

