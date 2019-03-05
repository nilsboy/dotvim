setlocal formatoptions=
" setlocal formatoptions=tacqwn

setlocal conceallevel=0

let &l:define = '\v#+\s+'
let b:outline = '#+\s+'

if exists("b:MyMarkdownFtpluginLoaded")
    finish
endif
let b:MyMarkdownFtpluginLoaded = 1

" " Don't auto-format in code blocks
" call OnSyntaxChange#Install('MarkdownPre', 'mkdSnippet.*', 1, 'a')
" autocmd User SyntaxMarkdownPreEnterA unsilent echo 'entered ' . &formatoptions
" autocmd User SyntaxMarkdownPreEnterA let g:MyMarkdownFormatoptions = &formatoptions | setlocal formatoptions=
" autocmd User SyntaxMarkdownPreLeaveA let &formatoptions = g:MyMarkdownFormatoptions
" autocmd User SyntaxMarkdownPreLeaveA unsilent echo 'left ' . &formatoptions

" MyInstall remark !npm install -g remark-cli remark-lint-maximum-line-length remark-lint-list-item-indent
" " NOTE: has no line wrap?
" let g:neoformat_markdown_myremark = {
"   \ 'exe': 'remark',
"   \ 'args': ['--no-color', '--silent',
"   \   '--rc-path', $CONTRIB . '/remark.json',
"   \ ],
"   \ 'stdin': 1,
"   \ }
"   " \ '--use' , 'remark-preset-lint-markdown-style-guide',
" let g:neoformat_enabled_markdown = [ 'myremark' ]

MyInstall prettier
let g:neoformat_markdown_myprettier = {
  \ 'exe': 'prettier',
  \ 'args': ['--no-color',
  \   '--parser', 'markdown',
  \   '--print-width' , '80',
  \   '--prose-wrap', 'always'
  \ ],
  \ 'stdin': 1,
  \ }
let g:neoformat_enabled_markdown = [ 'myprettier' ]

