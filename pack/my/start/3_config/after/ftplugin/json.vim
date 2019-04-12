" use arrays as comments
" let &l:comments = 's1:[",ex:"]'
" let &l:commentstring = '["%s"]'

setlocal wrap
let &l:commentstring = '// %s'

let &l:define = '\v^\s\s"\w.+[\{\[]+'
" let b:outline = '^\s{2,4}"\w.+[\{\[]+'
let b:outline = '\w+.*[\{\[]+'

let g:MyJsonStrict = 1

if exists("b:MyJsonFtpluginLoaded")
  finish
endif
let b:MyJsonFtpluginLoaded = 1

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
command! -nargs=* MyJsonStrict call MyJsonStrict (<f-args>)
call MyJsonStrict()

MyInstall prettier

MyInstall json2yaml
function! MyJsonToYaml() abort
  silent wall
  silent !cat % | json2yaml > %:r.yaml
  silent edit %:r.yaml

  " Fix broken output
  RemoveTrailingSpaces
  RemoveNewlineBlocks

  " Sometimes returns with a root indentation
  if search('\v^---\n  \w+\:') != 0
    normal <ie
  endif
endfunction

" setlocal ft=swagger

function! MyJsonFromJavascript() " no abort
  %s/\v^(\s*)(\w+)\:/\1"\2":/g
  %s/`/"/g
endfunction

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

