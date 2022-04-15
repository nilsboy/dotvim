finish
" NOTE: using my_db_config.vim now
" 
" Provides database access to many dbms
"
" NOTE: Needs modeline to be set even though it uses its own parser.
" Note: Does not work in neovim because it needs if_perl
" :h dbext
" :h sql
"
" To see the current setting run
" :DBGetOption
"
" Alternative: vim-sql-workbench
" Alternative?: https://news.ycombinator.com/item?id=13780587
" https://www.reddit.com/r/vim/comments/600t50/vimlike_database_client/
"
" Notes:
" - include other sql files with the 'read ' statement
"
" TODO
" :h dbext-integration
" take a look at the OMNI SQLComplete plugin
"
" TODO: checkout https://github.com/knq/usql
" TODO: allow to run sql snippets from markdown files
" TODO: checkout SQLUtilities plugin
" (https://github.com/vim-scripts/SQLUtilities)
" TODO: for table formatting checkout https://www.reddit.com/r/vim/comments/6b4s2b/how_to_work_with_columns_of_text/
" TODO: use special mapping for altering commands
" TODO: alert when more rows are found than requested
" TODO: fix encoding
" TODO: add submode for navigating screenwise in result
" TODO: keep header visible - using scrollbind?
" TODO: default limit
" TODO: sql formatter
" TODO: completion
" TODO: interruptable queries
" TODO: prepend table name in result if field is not a uniquely named result field
" TODO: allow to kill a query
" TODO: shorten long field values
" TODO: csv output
" TODO: persistent connection / display of running queries / killing of
" queries
" TODO: How to work with columns of text : vim
" (https://www.reddit.com/r/vim/comments/6b4s2b/how_to_work_with_columns_of_text/)

" To control the size of the Result window
let g:dbext_default_buffer_lines = 20

" dbext_default_prompt_for_variables
" - Allows you to specify if dbext should check for host variables >

" display the command that was run to generate the output
" let g:dbext_default_display_cmd_line = 1

" let g:dbext_default_use_tbl_alias = 'd'

" Debug
" let g:dbext_default_delete_temp_file = 1

let g:dbext_default_login_script_dir = stdpath("data") . '/dbext/login_scripts/'

let g:dbext_default_history_file = stdpath("data") . '/dbext/history.dbext'
let g:dbext_default_history_size = 9999

" Remove max single statement history entry size of 4K
let g:dbext_default_history_max_entry = 0

" let  g:dbext_default_dict_show_owner = 0

let  g:dbext_default_DBI_commit_on_disconnect = 0

" TODO - need to reconnect to take effect?
" let  g:dbext_default_DBI_column_delimiter = ";"

" If you want each buffer to have its OWN Result buffer
let g:dbext_default_use_sep_result_buffer = 1

" DBI limit
" Needs reload of sql file
let g:dbext_default_DBI_max_rows = 1100
" Set DBI limit of current buffer - 0 disables it
" :DBSetOption DBI_max_rows=0

PackAdd dbext.vim, {
  \ 'build': {
    \ 'unix': 'sudo apt-get install libmysqlclient-dev && cpanm DBI DBD::mysql',
  \ },
\ }

" Blob fetch length
" TODO DBSetOption driver_parms=LongReadLen=50

let g:dbext_default_usermaps = 0
" let g:dbext_map_prefix = '<leader><leader>db'
"
" TODO: deactivate sql complete
" :h omni-complete

let g:MyDbextResultsCount = 0
let g:MyDbextNewBufferNr = 0

nnoremap <leader>d <nop>
nnoremap <silent> <leader>di :silent! call MyDbextInfos()<cr>
nnoremap <silent> <leader>dc :DBListConnections<cr>
nnoremap <silent> <leader>dp :call MyDbextExecSql('SHOW PROCESSLIST', 'processlist')<cr>

nnoremap <silent> <leader>dd  yip:call MyDbextExecSql(@", 'query')<cr>
nnoremap <silent> <leader>dtc yiw:call MyDbextExecSql('SELECT COUNT(*) FROM ' . @", @" . '_count')<cr>

nnoremap <leader>dtt :call MyDbextRun('DBListTable ""', 'tables')<cr>
nnoremap <leader>dtd :call MyDbextRun('DBDescribeTable', 'desc')<cr>
nnoremap <leader>dts yiw:call MyDbextExecSql('SELECT * FROM ' . @", @" . '.contents')<cr>
nnoremap <leader>dtc yiw:call MyDbextExecSql('SHOW CREATE TABLE ' . @", @" . '.create_table')<cr>

function! MyDbextInfos() abort
  edit /tmp/database_infos.txt
  1,$d
  silent! only
  normal! i### Database profiles
  execute 'normal! o' . $HOME . '/etc/db_profiles_dbext.vim'
  normal! o
  normal! o### SQLs
  execute 'r! ls -t ' . $HOME . '/src/sql/*.sql'
  normal! 5gg
endfunction

function! MyDbextExecSql(sql, name) abort
  let sql = a:sql
  if sql =~ '^\s*select'
    if sql !~ 'limit '
      if sql =~ ';'
        throw 'Semicolons not allowed without limit'
      endif
      let sql .= ' LIMIT 100'
    endif
  endif
  call dbext#DB_execSql(sql)
  silent! call MyDbextAfter(a:name)
endfunction

function! MyDbextRun(command, name) abort
  execute a:command
  silent! call MyDbextAfter(a:name)
endfunction

" Callback called by dbext
function! DBextPostResult(db_type, buf_nr) abort
  " save new buffer nr
  let g:MyDbextNewBufferNr = a:buf_nr
endfunction

" Move result file to /tmp set filetype
function! MyDbextAfter(name) abort
  let name = a:name
  let g:MyDbextResultsCount = g:MyDbextResultsCount + 1
  if name == ''
    let name = expand('%:t')
  endif
  let name = name . '.' . g:MyDbextResultsCount
  let name = '/tmp/' . name . '.sqlresult'
  execute 'buffer ' . g:MyDbextNewBufferNr
  " TODO: test if vim-rooter works with write
  " needed otherwise the file might not exist jet!?!
  write
  execute ':Move! ' . fnameescape(name)
  " Needed to avoid remaps of dd etc by dbext
  mapclear <buffer>
  " let b:MySqlresultFirstLoad = 1

  silent! only
  " redraw!

  " Does not work
  " execute 'DBSetOption profile=' . g:dbext#currentProfile

  " Remove connection info and wrapped time
  normal! gg2dd
  " Duplicate separator line at bottom
  normal! 2ggyyGkp
  " does not work cursor is set by dbext after this
  " normal! gggm2j
  normal! GddggP
endfunction

if filereadable($HOME . "/etc/db_profiles_dbext.vim")
    execute "source " . $HOME . "/etc/db_profiles_dbext.vim"
endif

" let g:ftplugin_sql_omni_key = "<leader>so"
" let g:ftplugin_sql_omni_key = "<c-p>"

" let g:ftplugin_sql_omni_key_right = '<c-n>'
" let g:ftplugin_sql_omni_key_left  = '<c-p>'

" If new tables or columns are added to the database it may become
" necessary to clear the plugins cache.  The default map for this is: >
"     imap <buffer> <C-C>R <C-\><C-O>:call sqlcomplete#Map('ResetCache')<CR><C-X><C-O>

finish

" dbext Default mappings
" n  ,sE           <Plug>DBExecSQLUnderTopXCursor
" n  ,sT           <Plug>DBSelectFromTopXTable
" n  ,sal          :.,.DBVarRangeAssign<CR>
" n  ,sap          :'<,'>DBVarRangeAssign<CR>
" n  ,sas          :1,$DBVarRangeAssign<CR>
" n  ,sbp          <Plug>DBPromptForBufferParameters
" n  ,sdp          <Plug>DBDescribeProcedure
" n  ,sdpa         <Plug>DBDescribeProcedureAskName
" n  ,sdt          <Plug>DBDescribeTable
" n  ,sdta         <Plug>DBDescribeTableAskName
" n  ,se           <Plug>DBExecSQLUnderCursor
" n  ,sea          :1,$DBExecRangeSQL<CR>
" n  ,sel          :.,.DBExecRangeSQL<CR>
" n  ,sep          :'<,'>DBExecRangeSQL<CR>
" n  ,sh           <Plug>DBHistory
" n  ,slc          <Plug>DBListColumn
" n  ,slp          <Plug>DBListProcedure
" n  ,slr          :DBListVar<CR>
" n  ,slt          <Plug>DBListTable
" n  ,slv          <Plug>DBListView
" n  ,so           <Plug>DBOrientationToggle
" n  ,sq           <Plug>DBExecSQL
" n  ,st           <Plug>DBSelectFromTable
" n  ,sta          <Plug>DBSelectFromTableAskName
" n  ,stcl         <Plug>DBListColumn
" n  ,stw          <Plug>DBSelectFromTableWithWhere
"
" x  ,sE           <Plug>DBExecVisualTopXSQL
" x  ,sT           :<C-U>exec "DBSelectFromTableTopX '".DB_getVisualBlock()."'"<CR>
" x  ,sa           :DBVarRangeAssign<CR>
" x  ,sdp          :<C-U>exec "DBDescribeProcedure '".DB_getVisualBlock()."'"<CR>
" x  ,sdt          :<C-U>exec "DBDescribeTable '".DB_getVisualBlock()."'"<CR>
" x  ,se           <Plug>DBExecVisualSQL
" x  ,slc          :<C-U>exec "DBListColumn '".DB_getVisualBlock()."'"<CR>
" x  ,st           :<C-U>exec "DBSelectFromTable '".DB_getVisualBlock()."'"<CR>
" x  ,stcl         :<C-U>exec "DBListColumn '".DB_getVisualBlock()."'"<CR>

" Result buffer default mappings
" n  <Space>     *@:DBResultsToggleResize<CR>
" n  O           *@:DBOrientationToggle<CR>
" n  R           *@:DBResultsRefresh<CR>
" n  a           *@:call <SNR>284_DB_set('autoclose', (s:DB_get('autoclose')==1?0:1))<CR>
" x  d           *@:call dbext#DB_removeVariable()<CR>
" n  dd          *@:call dbext#DB_removeVariable()<CR>
" n  q           *@:DBResultsClose<CR>
