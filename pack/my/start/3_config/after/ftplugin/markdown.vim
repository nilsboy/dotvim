setlocal formatoptions=
" setlocal formatoptions=tacqwn

setlocal conceallevel=0

let &l:define = '\v#+\s+'
let b:outline = '#+\s+'

let b:formatter = 'prettier-markdown'

" " Don't auto-format in code blocks
" call OnSyntaxChange#Install('MarkdownPre', 'mkdSnippet.*', 1, 'a')
" autocmd User SyntaxMarkdownPreEnterA unsilent echo 'entered ' . &formatoptions
" autocmd User SyntaxMarkdownPreEnterA let g:MyMarkdownFormatoptions = &formatoptions | setlocal formatoptions=
" autocmd User SyntaxMarkdownPreLeaveA let &formatoptions = g:MyMarkdownFormatoptions
" autocmd User SyntaxMarkdownPreLeaveA unsilent echo 'left ' . &formatoptions
