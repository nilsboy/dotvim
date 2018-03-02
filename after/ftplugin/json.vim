" use arrays as comments
let &l:comments = 's1:[",ex:"]'
let &l:commentstring = '["%s"]'

" let &l:commentstring = '# %s'

if exists("b:MyJsonFtpluginLoaded")
    finish
endif
let b:MyJsonFtpluginLoaded = 1

" npm install -g json2yaml
nnoremap <buffer> <silent> <leader>gc :silent call MyJsonToYaml()<cr>
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

