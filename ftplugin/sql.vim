if exists("b:did_ftplugin_sql")
    finish
endif
let b:did_ftplugin_sql = 1

map <silent> S :w<CR>:,$r !reportmail %<CR>
