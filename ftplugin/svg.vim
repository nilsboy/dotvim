if exists("b:did_ftplugin_svg")
    finish
endif
let b:did_ftplugin_svg = 1

map <silent> W :call XMLTidy()<CR>
