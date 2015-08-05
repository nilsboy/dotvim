if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

map <silent> S :w<CR>:,$r !reportmail %<CR>
