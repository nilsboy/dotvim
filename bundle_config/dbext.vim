" Provides database access to many dbms
" TODO take a look at the OMNI SQLComplete plugin

" Remove max single statement history entry size of 4K
let g:dbext_default_history_max_entry = 0

" DBI limit
let g:dbext_default_DBI_max_rows = 100

" Whether to use separate result buffers for each file
let g:dbext_default_use_sep_result_buffer = 1

" TODO - is this limit?: How many lines the Result window should be
let g:dbext_default_buffer_lines = 1

" display the command that was run to generate the output
let g:dbext_default_display_cmd_line = 1

NeoBundle 'dbext.vim', {
  \ 'build': {
    \ 'unix': 'sudo apt-get install libmysqlclient-dev && cpanm DBI DBD::mysql',
  \ },
\ }

if filereadable($REMOTE_HOME . "/etc/db_profiles_dbext.vim")
    execute "source " . $REMOTE_HOME . "/etc/db_profiles_dbext.vim"
endif
nnoremap <leader>sp :execute "edit " . $REMOTE_HOME . "/etc/db_profiles_dbext.vim"<cr>

" Blog fetch length
" TODO :DBSetOption driver_parms=LongReadLen=50
