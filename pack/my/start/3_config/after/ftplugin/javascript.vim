" TODO: add?: https://github.com/lebab/lebab
" TODO: Get source of core node modules: i.e. process.binding("natives").assert

" NOTE: use `node --prof` for a call trace

" let &l:comments = '//:sr:/*,mb:*,ex:*/'
" let &l:comments = '//'
" let &l:commentstring = '// %s'

let b:formatter = 'prettier'
let b:tester = 'jest'

let b:myrunprg = 'ts-node'

" TODO:
" let b:formatter = 'my-javascript'

" support module filenames
setlocal iskeyword+=-

setlocal suffixesadd=.js,.node,.json,.ts
let &l:include = '\v<(require\([''"]|from\s+[''"])'
let &l:define = '\v(class|[:=]\s+function|Object\.defineProperty|\.prototype\.|^\s*const\s+|async\s|\s\w+\(.+\{|module\.exports|^\s*let\s*)'

let b:outline = ''
let b:outline .= '(.*jj.*'
" let b:outline .= '^\s*((async)\s*.+\(.*\)\s*{)\s*$|.*class \w+|constructor|module.exports'
" " tests
" let b:outline .= '|^\s*describe\s*\(|^\s*(test|it)\W'
" " function assignment
" let b:outline .= '|^\s*[\w\.]+\s*=\s*function\s+[\w\.]+\('
" " root assignments
" let b:outline .= '|^[\w\.]+\s*=\s*'
" " function
" let b:outline .= '|^\s*function\s+'
" let b:outline .= '|^\s*(export\s+)*async\s+function\s+'
" let b:outline .= '|^\s*(export\s+)'
" " static async findKeywords(db, product_variant_id) {
" let b:outline .= '|^\s*(static|async|interface|\s)*(\w+\(([\w,\s]*)\)\s+){\s*$'
" let b:outline .= '|^\s*interface\s*\w+\s*\{\s*'
" let b:outline .= '|^\s*declare\s*.*\{\s*'
" let b:outline .= '|^\s*declare function\s*.*'
" let b:outline .= '|.*jj.*$'

" export class Marking {
let b:outline .= '|^\s*export\s+'

" isEnabled(transition: Transition) {
let b:outline .= '|^\s*\w+\(.*?\)\s*{*\s*}*$'

let b:outline .= ')'

let b:match_words = '\<if\>:\<else\>,\<try\>:\<catch\>:\<finally\>,\<async\>:\<await\>:`,`'

nnoremap <buffer> <silent> K :call CocAction('doHover')<cr>
nmap <silent> <leader>lL <Plug>(coc-float-jump)

" setlocal path+=node_modules,~/src/node/lib

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

function! javascript#npmInstall() abort
  normal "zyiq
  let lib = getreg("z") 
  call nb#debug('Installing npm lib: ' . lib)
  execute 'terminal npm install ' . lib
  if lib !~ '@'
    execute 'terminal npm install -D @types/' . lib
  endif
endfunction
nmap <buffer> <silent><leader>lI :call javascript#npmInstall()<cr>

" nmap <buffer> <silent><leader>lI yiq:execute 'terminal npm install ' . @" . ' ; npm install -D @types/' . @"<cr>
" nmap <buffer> <silent><leader>lI yiq:execute 'terminal npm install ' . @" . '<cr>

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
