let &l:comments = 's1:{{! ,ex:}}'
let &l:commentstring = '{{! %s}}'

if exists("b:did_ftplugin_handlebars")
    finish
endif
let b:did_ftplugin_handlebars = 1

augroup MyHandlebarsAugroup
  autocmd!
  autocmd BufEnter *handlebars :let &l:comments = 's1:{{! ,ex:}}'
  autocmd BufEnter *handlebars :let &l:commentstring = '{{! %s}}'
augroup END

finish
let b:syntastic_checkers=['']
setlocal syntax=txt

