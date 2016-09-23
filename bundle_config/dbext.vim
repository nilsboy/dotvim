" Provides database access to many dbms
" :h dbext
" :h sql
"
" To see the current setting run
" :DBGetOption
"
" Alternative: vim-sql-workbench
"
" Notes:
" - include other sql files with the 'read ' statement
"
" TODO 
" :h dbext-integration
" take a look at the OMNI SQLComplete plugin
"
" To control the size of the Result window
let g:dbext_default_buffer_lines = 20

" dbext_default_prompt_for_variables
" - Allows you to specify if dbext should check for host variables >

" display the command that was run to generate the output
" let g:dbext_default_display_cmd_line = 1

" let g:dbext_default_use_tbl_alias = 'd'

" Debug
" let g:dbext_default_delete_temp_file = 1

let g:dbext_default_login_script_dir = g:vim.var.dir . 'dbext/login_scripts/'

let g:dbext_default_history_file = g:vim.var.dir . 'dbext/history.dbext'
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
let g:dbext_default_DBI_max_rows = 300
" Set DBI limit of current buffer - 0 disables it
" :DBSetOption DBI_max_rows=0

NeoBundle 'dbext.vim', {
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

let g:dbext#resultBufferId = 0

" Configure result buffer
function! DBextPostResult(db_type, buf_nr)

  let g:dbext#resultBufferId = g:dbext#resultBufferId + 1

  mapclear <buffer>

  " Remove connection info
  normal ggdd

  " Move connection info to the bottom
  " normal ggddG
  " put='#'
  " normal pkJgg

  " Duplicate speparator line at bottom
  normal 2ggyyGkp

  if g:dbext#bufferDescription == ''
    let g:dbext#bufferDescription = 'result.' . g:dbext#resultBufferId
  endif

  let l:file='/tmp/' . g:dbext#sourceBufferName . '.' . g:dbext#bufferDescription
  silent! execute '!rm ' l:file '&>/dev/null'

  " Move  file
  silent! execute 'file!' l:file

  set ft=dbext-result

  " Slows down large datasets
  " setlocal syntax=txt

  only
  redraw!

  " Does not work
  " execute 'DBSetOption profile=' . g:dbext#currentProfile

  lcd! -

endfunction

" autocmd CursorHold *.sql  :call DBExecSqlLimit100()

function! DbExtBefore(bufferDescription) abort

  " Prevent error last window can not be closed
  " function! dbext#DB_windowClose(buf_name)
  " endfunction

  let g:dbext#currentProfile = DB_listOption('profile')
  let g:dbext#sourceBufferName = expand('%:t')
  let g:dbext#bufferDescription = a:bufferDescription

  lcd! /tmp
endfunction

nnoremap <leader>se  :call DbExtBefore('') \| :DBExecSQLUnderCursor<cr>
nnoremap <leader>slt :call DbExtBefore('tables') \| :DBListTable ""<cr><c-w>
nnoremap <silent> <leader>st :call DBExecSqlLimit100()<cr>
nnoremap <leader>sdt :call DbExtBefore('desc') \| :DBDescribeTable<CR>

" DBSelectFromTable does not seem to honour the limit
function! DBExecSqlLimit100()
    let l:table = expand("<cword>")
    call DbExtBefore(l:table) 
    execute ":DBExecSQL select * from " l:table " limit 100"
endfunction

nnoremap <leader>sv :DBListConnections<cr>

if filereadable($REMOTE_HOME . "/etc/db_profiles_dbext.vim")
    execute "source " . $REMOTE_HOME . "/etc/db_profiles_dbext.vim"
endif
nnoremap <leader>sp :execute "edit " . $REMOTE_HOME . "/etc/db_profiles_dbext.vim" \| setlocal filetype=dbext-profile<cr>

let $SQL_FILES_DIR = $HOME . '/src/sql/'
nnoremap <silent> <leader>sf :Unite
    \ -buffer-name=sql-files
    \ -smartcase
    \ script-file:find-and-limit\ --dir\ $SQL_FILES_DIR\ --abs
    \ <cr><esc>

" let g:ftplugin_sql_omni_key = "<leader>so"
" let g:ftplugin_sql_omni_key = "<c-p>"

" let g:ftplugin_sql_omni_key_right = '<c-n>'
" let g:ftplugin_sql_omni_key_left  = '<c-p>'

" If new tables or columns are added to the database it may become
" necessary to clear the plugins cache.  The default map for this is: >
"     imap <buffer> <C-C>R <C-\><C-O>:call sqlcomplete#Map('ResetCache')<CR><C-X><C-O>

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
