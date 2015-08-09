if exists("b:did_ftplugin_xml")
    finish
endif
let b:did_ftplugin_xml = 1

map <silent> W :call XMLTidy()<CR>
