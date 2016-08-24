if exists("b:did_ftplugin_sql")
    finish
endif
let b:did_ftplugin_sql = 1

" map <silent> S :w<CR>:,$r !reportmail %<CR>

" let s:new_title = 'Srvr: ' . DB_listOption('profile')
" exec 'DBSetOption custom_title=' . s:new_title

let g:formatters_sql = ['sqlformatter']
let g:formatdef_sqlformatter = '"sql-format"'
