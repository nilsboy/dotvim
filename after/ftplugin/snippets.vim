" This also prevents the ftplugin from UltiSnips to run and mess with
" expandtab
if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin = 1

augroup My_Snippets_augroup_SyntaxFix
  autocmd!
  autocmd Syntax snippets highlight snipLeadingSpaces NONE
augroup END

