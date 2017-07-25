setlocal syntax=yaml

nnoremap <buffer> <leader>bl :silent! call SwaggerLint()<cr>

if exists("b:did_ftplugin_swagger")
    finish
endif
let b:did_ftplugin_swagger = 1

" Only create once globally - otherwise the autocmd stops working when opening
" a second file
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

augroup MySwaggerAugroupLint
  autocmd!
  " TODO: TextChanged stops UltiSnips snippet expansion
  " autocmd TextChanged,InsertLeave * :call SwaggerLint()
  autocmd BufWritePost *.swagger.* :silent! call SwaggerLint()
augroup END

finish

" TODO rename to openapi?

" Tools
" - swagger-parser: no location in validate output
" - swagger-tools: no location in validate output
" - swagger-validator: is broken or cannot handle swagger version 2
" - api-spec-converter: does not validate much (types, spec paths, ...) and only
"   validates after conversion

