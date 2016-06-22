if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

nmap <buffer> <silent> <CR> :call RestCall()<cr>
function! RestCall(...)
    call VrcQuery()
    only
    edit __REST_response__
    " Needs to be called twice!?!
    setlocal filetype=json
    setlocal filetype=json
    setlocal modifiable
endfunction
