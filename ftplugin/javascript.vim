if exists("b:did_ftplugin_javascript")
    finish
endif
let b:did_ftplugin_javascript = 1

map <buffer><silent><leader>w :Esformatter<CR>:SyntasticCheck<CR>

" Tab spacing
setlocal tabstop=2

" Shift width (moved sideways for the shift command)
setlocal shiftwidth=2

setlocal makeprg=npm\ test
