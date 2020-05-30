" TODO: add?: https://github.com/lebab/lebab
" TODO: Get source of core node modules: i.e. process.binding("natives").assert

let b:formatter = 'prettier'
let b:tester = 'jest'
" TODO:
" let b:formatter = 'my-javascript'

" support module filenames
setlocal iskeyword+=-

setlocal suffixesadd=.js,.node,.json
let &l:include = '\v<(require\([''"]|from\s+[''"])'
let &l:define = '\v(class|[:=]\s+function|Object\.defineProperty|\.prototype\.|^\s*const\s+|async\s|\s\w+\(.+\{|module\.exports|^\s*let\s*)'
let b:outline = '(^\s*class\s*.+\{|^\s*(async)*\s*function\s+.+\{|^\s*(test|id)\s*\(.+\{|^\s*(static)*\s*(async)*\s*\w+\s*\(.+\{|^[\w\.]+\s*\=)'
" let b:outline = '^\s*(?!if)\s*(static)*\s*(async)*\s*\w+\s*\(.+\{'
" const deactivateBundleItem = async(item) => {
let b:outline = '^((?!\s*(if|for|while))\s*(\b(async|static|function)\b)*\s*\w+\s*\(.*\{$|\s*class\s+\w+\b|[\w\.]+\s*=)|^\s{0,2},*\s*\w+\s*\:*\s*\{$'

let b:match_words = '\<if\>:\<else\>,\<try\>:\<catch\>:\<finally\>,\<async\>:\<await\>'
" *b:match_skip*
" *b:match_ignorecase*

nnoremap <buffer> <silent> K :call CocAction('doHover')<cr>

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

function! javascript#fromPerl()
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
