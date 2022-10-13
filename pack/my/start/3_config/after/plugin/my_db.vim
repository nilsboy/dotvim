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
" TODO: checkout https://github.com/chrisbra/csv.vim
"
" DONE: fix encoding
" DONE: shorten long field values
" DONE: default limit

let g:MyDbConfigConfigDir = $HOME . '/.config/dbdump'
let g:MyDbConfigProfileName = 'specifyProfileName'

nnoremap <leader>d <nop>

nnoremap <silent> <leader>di  :call MyDbInfos()<cr>
nnoremap <silent> <leader>dp  mz"zyiW:call MyDbConfigSetProfile(@z)<cr>

nnoremap <silent> <leader>dP  mz:call MyDbExecSql('SHOW PROCESSLIST', '[processlist]')<cr>

nnoremap <silent> <leader>dd  mz"zyip:call MyDbExecSql(@z, '[query]', '', 1)<cr>

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

  " TODO: hack
  " Restore cursor position - `normal y` moves cursor - in manual mode prevented
  " by easyclip plugin
  silent! normal! `z

  let limit = g:MyDbConfigLimit

  if limit
    let limit = ' --limit ' . limit . ' '
  endif

  wall
	let fileName = name
  if add_counter
    let g:MyDbConfigQueryId = g:MyDbConfigQueryId + 1
	  let fileName = fileName . '.' . g:MyDbConfigQueryId
  endif
  let fileName = fileName . '.sqlresult'
	let fileName = nb#mktempSimple(g:MyDbConfigProfileName, fileName)

	silent execute 'edit ' . fileName
  silent! normal! 1,$"_dd

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
  call nb#debug('Setting db profile name: ' .. g:MyDbConfigProfileName)
endfunction

function! MyDbInfos() abort
  let file = nb#mktempSimple("sql", "db-infos")
  silent execute 'edit ' . file
  " 1,$"_d
  normal! i### SQLs
  execute 'r! ls -t ' . $HOME . '/src/sql/queries/*.sql'
  execute 'r! ls -t ' . $HOME . '/src/sql/queries/*.md'
  normal! o
  normal! o
  normal! i### Database profiles
  execute 'normal! o' . g:MyDbConfigConfigDir . '/default.yaml'
  execute 'normal! o' . $HOME . '/src/myconf/README.md'
  execute 'normal! o' . $HOME . '/src/dbdump/README.md'
  normal! o
  normal! o
  normal! i### Table Data Excerpts
  execute 'normal! o' . $HOME . '/src/sql/table-data-excerpt/README.md'
  normal! o
  normal! o### Mappings
  RedirAppend map \\d
  normal! gg
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
