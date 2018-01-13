" RDBMS client
"
" SEE ALSO: Alternative: vim-sql-workbench
" SEE ALSO: Alternative?: https://news.ycombinator.com/item?id=13780587
"           https://www.reddit.com/r/vim/comments/600t50/vimlike_database_client/
"
" SEE ALSO: :h sql
"
" TODO: Completion:
" - take a look at the OMNI SQLComplete plugin
" - include other sql files with the 'read ' statement
" - deactivate sql complete
"   :h omni-complete

" TODO: dump whole db for grepping
" TODO: checkout https://github.com/knq/usql
" TODO: allow to run sql snippets from markdown files
" TODO: checkout SQLUtilities plugin
" (https://github.com/vim-scripts/SQLUtilities)
" TODO: for table formatting checkout https://www.reddit.com/r/vim/comments/6b4s2b/how_to_work_with_columns_of_text/
" TODO: use special mapping for altering commands
" TODO: alert when more rows are found than requested
" TODO: add submode for navigating screenwise in result
" TODO: keep header visible - using scrollbind?
" TODO: sql formatter
" TODO: interruptable queries
" TODO: prepend table name in result if field name is not uniq
" TODO: allow to kill a query
" TODO: csv output
" TODO: persistent connection / display of running queries / killing of
" queries
" TODO: How to work with columns of text : vim
" (https://www.reddit.com/r/vim/comments/6b4s2b/how_to_work_with_columns_of_text/)
"
" DONE: fix encoding
" DONE: shorten long field values
" DONE: default limit

let g:MyDbConfigConfigDir = $HOME . '/.config/dbdump'
let g:MyDbConfigProfileName = 'specifyProfileName'

nnoremap <leader>d <nop>

nnoremap <leader>di     :call MyDbInfos()<cr>
nnoremap <leader>dp     :call MyDbExecSql('SHOW PROCESSLIST', '[processlist]')<cr>

nnoremap <leader>dtt    :call MyDbExecSql('SHOW TABLES', '[tables]')<cr>
nnoremap <leader>dtc mayiw:call MyDbExecSql('SHOW CREATE TABLE ' . @", @" . '.[create_table]')<cr>
nnoremap <leader>dtd mayiw:call MyDbExecSql('DESCRIBE '. @", @" . '.[desc]')<cr>

" nnoremap <leader>dd  yip``:call MyDbExecSql(@", '[query]')<cr>
nnoremap <leader>dd  mayip:call MyDbExecSql(@", '[query]')<cr>
nnoremap <leader>dst mayiw:call MyDbExecSql('SELECT * FROM ' . @", @" . '.[contents]')<cr>
nnoremap <leader>dsc mayiw:call MyDbExecSql(
      \ 'SELECT COUNT(*) FROM ' . @", @" . '.[count]')<cr>

let g:MyDbConfigQueryId = 0
function! MyDbExecSql(sql, name) abort
  " TODO: hack
  " Restore cursor position - `normal y` moves cursor - in manual mode prevented
  " by easyclip plugin
  normal! `a

  wall
  let g:MyDbConfigQueryId = g:MyDbConfigQueryId + 1
	let fileName = '/tmp/' . a:name . '.' . g:MyDbConfigQueryId . '.sqlresult'
  if filereadable(fileName)
    call delete(fileName)
  endif
	silent execute 'edit ' . fileName
  " silent 1,$d
	let a = systemlist('NODE_CONFIG_DIR=' . g:MyDbConfigConfigDir
        \ . ' dbquery --profile ' . g:MyDbConfigProfileName, a:sql, 1)
	call append(0, a)
  silent update
	normal! gg
endfunction

" # vimex: MyDbConfigSetProfile pidb-db-dev
command! -nargs=* MyDbConfigSetProfile call MyDbConfigSetProfile (<f-args>)
function! MyDbConfigSetProfile(...) abort
  let g:MyDbConfigProfileName = a:1
endfunction

function! MyDbInfos() abort
  edit /tmp/database_infos.txt
  1,$d
  normal! i### Database profiles
  execute 'normal! o' . g:MyDbConfigConfigDir . '/default.yaml'
  normal! o
  normal! o### SQLs
  execute 'r! ls -t ' . $REMOTE_HOME . '/src/sql/*.sql'
  normal! 5gg
endfunction
