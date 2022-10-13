finish
" NOTE: unnecessary just for editing code blocks because mkdSnippetSQL is
" already set by some markdown filtype plugin.
" call SyntaxRange#Include('```sql', '```', 'sql', 'NonText')

" NOTE: works but unnecessary just for editing code blocks. Instead
" mkdSnippetSQL should be used to select the code block.
" TBD: set filetype for NrrwRgn plugin by syntax group i.e. mkdSnippetSQL=sql
" by matching mkdSnippetSQL etc.
call OnSyntaxChange#Install('Sql', 'mkdSnippetSQL', 1, 'a')
augroup markdown#augroupSqlRegion
  autocmd!
  autocmd User SyntaxSqlEnterA let b:region_filetype = 'sql'
  autocmd User SyntaxSqlLeaveA unlet! b:region_filetype

  autocmd User SyntaxSqlEnterA unsilent echo 'enter'
  autocmd User SyntaxSqlLeaveA unsilent echo 'leave'
augroup END
