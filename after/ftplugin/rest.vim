let b:vrc_output_buffer_name = expand('%') . '.result'

nnoremap <buffer> <silent> <CR> :call MyRestConsoleCall()<cr><cr>

let &l:define = '\v^(##|GET|POST)\s'
