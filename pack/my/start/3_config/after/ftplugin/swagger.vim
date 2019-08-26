augroup MySwaggerAugroupLint
  autocmd!
  " TODO: TextChanged stops UltiSnips snippet expansion
  " autocmd TextChanged,InsertLeave * :call MySwaggerLint()
  autocmd BufWritePost <buffer> :silent! call MySwaggerLint()
augroup END

" let &l:define = '\v^(  /|  \w.+\:|    (post|get|put|patch|delete)\:)'
let b:outline = '^(  /|  \w.+\:|    (post|get|put|patch|delete)\:)'
let b:outline = '^(\s\s[/\w]|\w).+$'

let g:neoformat_swagger_prettier = {
      \ 'exe': 'prettier'
      \ ,'args': ['--prose-wrap=always'] 
      \ }

let g:neoformat_enabled_swagger = [ 'prettier' ]

if exists("g:did_ftplugin_swagger")
    finish
endif
let g:did_ftplugin_swagger = 1

function! MySwaggerLint() abort
  silent wall
  setlocal errorformat=%m
  let &l:makeprg="swagger-tools validate " . expand('%:p')
  " Neomake!
  silent lmake!
  lclose
  lwindow
  silent! wincmd w
endfunction

finish

" TODO rename to openapi?

" Tools
" - swagger-parser: no location in validate output
" - swagger-tools: no location in validate output
" - swagger-validator: is broken or cannot handle swagger version 2
" - api-spec-converter: does not validate much (types, spec paths, ...) and only
"   validates after conversion

