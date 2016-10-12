setlocal syntax=yaml

if exists("b:did_ftplugin_swagger")
    finish
endif
let b:did_ftplugin_swagger = 1

" TODO rename to openapi?

autocmd BufWritePost *.swagger.{yaml,json} :call SwaggerLint()

function! SwaggerLint() abort
  r!swagger-lint %
  " redraw!
endfunction
