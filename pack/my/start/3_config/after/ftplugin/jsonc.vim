" use arrays as comments
" let &l:comments = 's1:[",ex:"]'
" let &l:commentstring = '["%s"]'

setlocal conceallevel=0

let b:formatter = 'prettier-json'

setlocal wrap
let &l:commentstring = '// %s'

let &l:define = '\v^\s\s"\w.+[\{\[]+'
" let b:outline = '^\s{2,4}"\w.+[\{\[]+'
let b:outline = '\w+.*[\{\[]+'

" Exclude quotes.
" Breaks coc.
" setlocal iskeyword=1-33,35-255

if exists("b:MyJsonCFtpluginLoaded")
  finish
endif
let b:MyJsonCFtpluginLoaded = 1

let g:MyJsonStrict = 1

function! MyJsonStrict(...) abort
  let cmd = join(a:000)
  if g:MyJsonStrict
    let g:MyJsonStrict = 0
    highlight! default link jsonCommentError Comment
    highlight! default link jsonTrailingCommaError NONE
  else
    let g:MyJsonStrict = 1
    highlight! default link jsonCommentError Error
    highlight! default link jsonTrailingCommaError Error
  endif
endfunction
command! -nargs=* JsonStrict call MyJsonStrict (<f-args>)
call MyJsonStrict()

MyInstall prettier

MyInstall json2yaml
function! MyJsonToYaml() abort
  silent wall
  let src = expand("%:p")
  let dst = nb#mktemp("json2yaml") . expand("%:t:r") . '.yaml'
  call nb#debug('### jj6 src: ' . src)
  execute '!json2yaml ' . src . ' > ' . dst
  silent execute 'edit ' . dst

  " Fix broken output
  RemoveTrailingSpaces
  RemoveNewlineBlocks

  " Sometimes returns with a root indentation
  if search('\v^---\n  \w+\:') != 0
    normal <ie
  endif
endfunction
command! -nargs=* JsonToYaml call MyJsonToYaml(<f-args>)

" setlocal ft=swagger

function! MyJsonFromJavascript() " no abort
  %s/\v^(\s*)(\w+)\:/\1"\2":/g
  %s/`/"/g
endfunction
command! -nargs=* JsonFromJavascipt call MyJsonFromJavascript(<f-args>)

" " TODO: use Commentary User autocmd instead
" nnoremap <silent> <buffer> gcc :call MyJsonCommenter()<cr>
" function! MyJsonCommenter() abort
"   s/\v"/\\"/g
"   unmap <buffer> gcc
"   normal gcc
"   nnoremap <silent> <buffer> gcc :call MyJsonCommenter()<cr>
" endfunction

" augroup MyJsonAugroupEscape
"   autocmd!
"   autocmd User CommentaryPost :s/\v"/\\"/g
"   autocmd User CommentaryPost :echo "post"
" augroup END

MyInstall gron pkexec apt install gron
function! MyJsonToGron() abort
  silent wall
  let src = expand("%")
  let dst = nb#mktemp("gron") . expand("%:r") . '.js'
  silent execute '!gron ' . src . ' > ' . dst
  silent execute 'edit ' . dst
endfunction
command! -nargs=* JsonToGron call MyJsonToGron(<f-args>)

