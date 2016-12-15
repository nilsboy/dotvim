setlocal syntax=yaml

if exists("b:did_ftplugin_swagger")
    finish
endif
let b:did_ftplugin_swagger = 1

" TODO rename to openapi?

" autocmd BufWritePost *.swagger.{yaml,json} :call SwaggerLint()

function! SwaggerLint() abort
  r!swagger-tools validate %
  " r!swagger-lint %
  " redraw!
endfunction

finish

" Tools
" - swagger-parser: no location in validate output
" - swagger-tools: no location in validate output
" - swagger-validator: is broken or cannot handle swagger version 2
" - api-spec-converter: does not validate much (types, spec paths, ...) and only
"   validates after conversion
