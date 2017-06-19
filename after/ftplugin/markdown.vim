" Use comment string for quoting
" let &l:commentstring = '> %s'

if exists("b:MyMarkdownFtpluginLoaded")
    finish
endif
let b:MyMarkdownFtpluginLoaded = 1

" Don't auto-format in code blocks
call OnSyntaxChange#Install('MarkdownPre', 'mkdSnippet.*', 1, 'a')
autocmd User SyntaxMarkdownPreEnterA unsilent echo 'entered ' . &formatoptions
autocmd User SyntaxMarkdownPreEnterA let g:MyMarkdownFormatoptions = &formatoptions | set formatoptions=
autocmd User SyntaxMarkdownPreLeaveA let &formatoptions = g:MyMarkdownFormatoptions
autocmd User SyntaxMarkdownPreLeaveA unsilent echo 'left ' . &formatoptions

" npm install --global remark-cli remark-lint-maximum-line-length

let g:neoformat_markdown_myremark = {
  \ 'exe': 'remark',
  \ 'args': ['--no-color', '--silent',
  \ '--rc-path', g:vim.contrib.etc.dir . 'remark.json',
  \ ],
  \ 'stdin': 1,
  \ }
  " \ '--use' , 'remark-preset-lint-markdown-style-guide',

let g:neoformat_enabled_markdown = [ 'myremark' ]

" " vim-markdown defines b:* which breaks list auto-formatting of &formatoptions
" function! MyMarkdownForceSettings() abort
"   let &comments = 'nb:>'
"   " set formatoptions+=t
"   " set formatoptions-=c
" endfunction
" augroup MyMarkdownAugroupForceComments
"   autocmd!
"   autocmd BufWinEnter *.md call MyMarkdownForceSettings()
" augroup END

