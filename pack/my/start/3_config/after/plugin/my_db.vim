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

nnoremap <leader>di     :call MyDbInfos()<cr>
nnoremap <leader>dp     :call MyDbExecSql('SHOW PROCESSLIST', '[processlist]')<cr>

nnoremap <leader>dd  mayip:call MyDbExecSql(@", '[query]')<cr>
nnoremap <leader>dD  mayip:call MyDbExecSql(@", '[query]', '', 1)<cr>

nnoremap <leader>dtt    :call MyDbExecSql('SHOW TABLES', '[tables]')<cr>
nnoremap <leader>dtc mayiw:call MyDbExecSql('SHOW CREATE TABLE ' . @", @" . '.[create_table]', '--yaml')<cr>
nnoremap <leader>dtd mayiw:call MyDbExecSql('DESCRIBE '. @", @" . '.[desc]')<cr>
nnoremap <leader>dts mayiw:call MyDbExecSql('SELECT * FROM ' . @" . ' ORDER BY 1 DESC', @" . '.[contents]')<cr>
" some tables take too long when queried in DESC order
nnoremap <leader>dtS mayiw:call MyDbExecSql('SELECT * FROM ' . @", @" . '.[contents]')<cr>
nnoremap <leader>dtC mayiw:call MyDbExecSql(
      \ 'SELECT COUNT(*) FROM ' . @", @" . '.[count]')<cr>

let g:MyDbConfigOptions = ''
nnoremap <silent> <leader>doo :let g:MyDbConfigOptions = ''<cr>
nnoremap <silent> <leader>doy :let g:MyDbConfigOptions .= ' --yaml '<cr>
nnoremap <silent> <leader>doj :let g:MyDbConfigOptions .= ' --json '<cr>
nnoremap <silent> <leader>doc :let g:MyDbConfigOptions .= ' --csv '<cr>

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
  let print_query = get(a:000, 3, '')

  " TODO: hack
  " Restore cursor position - `normal y` moves cursor - in manual mode prevented
  " by easyclip plugin
  silent! normal! `a

  let limit = g:MyDbConfigLimit
  " call nb#info('limit:', limit)

  if limit
    let limit = ' --limit ' . limit . ' '
  endif

  wall
  let g:MyDbConfigQueryId = g:MyDbConfigQueryId + 1
	let fileName = '/tmp/' . name . '.' . g:MyDbConfigQueryId . '.sqlresult'
  if filereadable(fileName)
    call delete(fileName)
  endif

	silent execute 'edit ' . fileName
  silent! normal! 1,$"_dd

  if print_query
    call append(0, ['### Query:', '', sql, '', '### Result:', ''])
    %s/\%x00/\r/ge
  endif

	let cmd = 'NODE_CONFIG_DIR=' . g:MyDbConfigConfigDir
        \ . ' dbquery' 
        \ . ' --profile ' . g:MyDbConfigProfileName
        \ . limit
        \ . g:MyDbConfigOptions 
        \ . cmd_options 

  " call nb#info('cmd:', cmd)

	let a = systemlist(cmd, sql, 1)
	call append('$', a)

  silent update
	keepjumps normal! G"_dd
	keepjumps normal! gg"_dd
endfunction

" # vimex: MyDbConfigSetProfile pidb-db-dev
command! -nargs=* MyDbConfigSetProfile call MyDbConfigSetProfile (<f-args>)
function! MyDbConfigSetProfile(...) abort
  let g:MyDbConfigProfileName = a:1
endfunction

function! MyDbInfos() abort
  edit /tmp/database_infos.txt
  1,$"_d
  normal! i### Database profiles
  execute 'normal! o' . g:MyDbConfigConfigDir . '/default.yaml'
  execute 'normal! o' . $HOME . '/src/myconf/README.md'
  normal! o
  normal! o
  normal! i### Table Data Excerpts
  execute 'normal! o' . $HOME . '/src/sql/table-data-excerpt/README.md'
  normal! o
  normal! o### SQLs
  execute 'r! ls -t ' . $HOME . '/src/sql/*.sql'
  normal! o
  normal! o### Mappings
  RedirAppend map \\d
  normal! 8gg0
endfunction

nnoremap <leader>dK mayiw:call MyDbConfigKillProcess(@")<cr>
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
