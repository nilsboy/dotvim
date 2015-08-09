if exists("b:did_ftplugin_xhtml")
    finish
endif
let b:did_ftplugin_xhtml = 1

map <silent> W :call XMLTidy()<CR>
