" map <silent> S :w<CR>:,$r !reportmail %<CR>

" let s:new_title = 'Srvr: ' . DB_listOption('profile')
" exec 'DBSetOption custom_title=' . s:new_title

setlocal syntax=txt
" let &l:commentstring = '# %s'

if exists("b:MySqlFtpluginLoaded")
    finish
endif
let b:MySqlFtpluginLoaded = 1

let g:formatters_sql = ['sqlformatter']
let g:formatdef_sqlformatter = '"sql-format"'

" TODO npm sqlite3 seems to have a good formatter

let &l:define = '\v^#+\ .+$'
