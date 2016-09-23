" breaks formatting...
" let g:vrc_show_command = 1

let b:vrc_output_buffer_name = expand('%') . '.result'

nnoremap <buffer> <silent> <CR> :call RestCall()<cr>

if exists("b:did_ftplugin_rest")
    finish
endif
let b:did_ftplugin_rest = 1

function! RestCall(...)
    call VrcQuery()
    only
    execute 'edit ' b:vrc_output_buffer_name
    setlocal filetype=txt
    setlocal modifiable
endfunction
