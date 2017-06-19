" Used by vim-rest-console

if exists("b:MyRestresultFtpluginLoaded")
    finish
endif
let b:MyRestresultFtpluginLoaded = 1

setlocal modifiable
setlocal filetype=json
" Remove header
" normal! ggdap
" Neoformat
