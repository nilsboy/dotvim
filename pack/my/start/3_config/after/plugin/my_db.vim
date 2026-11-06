" RDBMS client
"
" NOTE: terminal spreadsheets https://www.reddit.com/r/vim/comments/7vtfh3/sc_is_a_vimlike_spreadsheet/
"
" SEE ALSO: Alternative: vim-sql-workbench
" SEE ALSO: Alternative?: https://news.ycombinator.com/item?id=13780587
"           https://www.reddit.com/r/vim/comments/600t50/vimlike_database_client/
"
" SEE ALSO: :h sql
"
" TBD: Completion:
" - take a look at the OMNI SQLComplete plugin
" - include other sql files with the 'read ' statement
" - deactivate sql complete
"   :h omni-complete

" TBD: dump whole db for grepping
" TBD: checkout https://github.com/knq/usql
" TBD: allow to run sql snippets from markdown files
" TBD: checkout SQLUtilities plugin
" (https://github.com/vim-scripts/SQLUtilities)
" TBD: for table formatting checkout https://www.reddit.com/r/vim/comments/6b4s2b/how_to_work_with_columns_of_text/
" TBD: use special mapping for altering commands
" TBD: alert when more rows are found than requested
" TBD: add submode for navigating screenwise in result
" TBD: keep header visible - using scrollbind?
" TBD: sql formatter
" TBD: interruptable queries
" TBD: prepend table name in result if field name is not uniq
" TBD: allow to kill a query
" TBD: csv output
" TBD: persistent connection / display of running queries / killing of
" queries
" TBD: How to work with columns of text : vim
" (https://www.reddit.com/r/vim/comments/6b4s2b/how_to_work_with_columns_of_text/)
" TBD: checkout https://github.com/chrisbra/csv.vim
"
" DONE: fix encoding
" DONE: shorten long field values
" DONE: default limit

let g:MyDbConfigConfigDir = $HOME . '/.config/dbdump'
let g:MyDbConfigProfileName = 'specifyProfileName'
let g:MyDbInfos = $HOME . '/src/db/README.md'

nnoremap <leader>d <nop>

nnoremap <silent> <leader>di :execute("edit " . g:MyDbInfos)<cr>
nnoremap <silent> <leader>dp mz"zyiw:call MyDbConfigSetProfile(@z)<cr>

nnoremap <silent> <leader>dP mz:call MyDbExecSql('SHOW PROCESSLIST', '[processlist]')<cr>

nnoremap <silent> <leader>dd mz"zyip:call MyDbExecSql(@z, '[query]', '', 1)<cr>

nnoremap <silent> <leader>dtt mz:call MyDbExecSql('SHOW TABLES', '[tables]')<cr>
nnoremap <silent> <leader>dtD mz:call MyDbExecSql('SHOW DATABASES', '[databases]')<cr>
nnoremap <silent> <leader>dtc mz"zyiw:call MyDbExecSql('SHOW CREATE TABLE ' . @z, @z . '.[create_table]', '--yaml')<cr>
nnoremap <silent> <leader>dtd mz"zyiw:call MyDbExecSql('DESCRIBE '. @z, @z . '.[desc]')<cr>
nnoremap <silent> <leader>dts mz"zyiw:call MyDbExecSql('SELECT * FROM ' . @z . ' ORDER BY 1 DESC', @z)<cr>
" some tables take too long when queried in DESC order
nnoremap <silent> <leader>dtS mz"zyiw:call MyDbExecSql('SELECT * FROM ' . @z, @z . '.[contents]')<cr>
nnoremap <silent> <leader>dtC mz"zyiw:call MyDbExecSql(
      \ 'SELECT COUNT(*) FROM ' . @z, @z . '.[count]')<cr>

let g:MyDbConfigOptions = ''
nnoremap <silent> <leader>doo :let g:MyDbConfigOptions = ''<cr>
nnoremap <silent> <leader>doy :let g:MyDbConfigOptions .= ' --yaml '<cr>
nnoremap <silent> <leader>doj :let g:MyDbConfigOptions .= ' --json '<cr>
nnoremap <silent> <leader>doc :let g:MyDbConfigOptions .= ' --csv '<cr>
nnoremap <silent> <leader>doi :let g:MyDbConfigOptions .= ' --sql-insert'<cr>

let g:MyDbConfigLimit = 10000
nnoremap <silent> <leader>dll :let g:MyDbConfigLimit = 10000<cr>
nnoremap <silent> <leader>dl1 :let g:MyDbConfigLimit = 1<cr>
nnoremap <silent> <leader>dlx :let g:MyDbConfigLimit = 10<cr>
nnoremap <silent> <leader>dlc :let g:MyDbConfigLimit = 100<cr>
nnoremap <silent> <leader>dlm :let g:MyDbConfigLimit = 1000<cr>
nnoremap <silent> <leader>dl0 :let g:MyDbConfigLimit = ''<cr>

let g:MyDbConfigQueryId = 0
function! MyDbExecSql(...) abort
  let sql = get(a:000, 0, '')
  let name = get(a:000, 1, '')
  let cmd_options = get(a:000, 2, '')
  let add_counter = get(a:000, 3, 0)

  " TBD: hack
  " Restore cursor position - `normal y` moves cursor - in manual mode prevented
  " by easyclip plugin
  silent! normal! `z

  let limit = g:MyDbConfigLimit

  if limit
    let limit = ' --limit ' . limit . ' '
  endif

  " TBD: test
  let filename = nb#createTempBuffer('sql', name, 'sqlresult')
  " TBD: remove?:
  " silent! normal! 1,$"_dd

  call nb#debug('Query: ' . sql)

	let cmd = 'NODE_CONFIG_DIR=' . g:MyDbConfigConfigDir
        \ . ' dbquery' 
        \ . ' --profile ' . g:MyDbConfigProfileName
        \ . limit
        \ . g:MyDbConfigOptions 
        \ . cmd_options 

  call nb#debug('cmd: '. cmd)

	let a = systemlist(cmd, sql, 1)
	call append('$', a)

  silent update
	keepjumps normal! G"_dd
	keepjumps normal! gg"_dd
endfunction

" # vimex: MyDbConfigSetProfile my-db-profile
command! -nargs=* MyDbConfigSetProfile call MyDbConfigSetProfile (<f-args>)
function! MyDbConfigSetProfile(...) abort
  silent! normal! `z
  let g:MyDbConfigProfileName = a:1
  call nb#info('Setting db profile name: ' .. g:MyDbConfigProfileName)
endfunction

nnoremap <leader>dK mz"zyiw:call MyDbConfigKillProcess(@z)<cr>
function! MyDbConfigKillProcess(processId) abort
  silent! normal! `a
  let confirmation = input('Kill process ' . a:processId . '? ', 'y')
  if confirmation != 'y'
    echo "\n"
    call nb#info('Kill cancelled.')
    return
  endif
  call nb#info('Killing process: ' . a:processId)
  call MyDbExecSql('KILL ' . a:processId, 'Kill process ' . a:processId)
endfunction

" nnoremap <leader>dh     ggyy``P<cr>
nnoremap <silent> <leader>dh :call MyDbConfigHeaderSplit()<cr>
function! MyDbConfigHeaderSplit() abort
  set scrollopt=hor
  set scrollbind
  split
  wincmd k
  set scrollbind
  :0
  :0 wincmd _
  wincmd j
endfunction
