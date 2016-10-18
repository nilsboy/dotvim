let b:vrc_output_buffer_name = expand('%') . '.result'

nnoremap <buffer> <silent> <CR> :call RestCall()<cr>
