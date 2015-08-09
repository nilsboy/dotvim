if exists("b:did_ftplugin_wsdd")
    finish
endif
let b:did_ftplugin_wsdd = 1

map <silent> W :call XMLTidy()<CR>
