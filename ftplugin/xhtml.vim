if exists("b:did_ftplugin_xhtml")
    finish
endif
let b:did_ftplugin_xhtml = 1

map <silent><leader>W :call XMLTidy()<CR>
