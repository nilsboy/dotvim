" A REST console for Vim.
NeoBundle 'diepm/vim-rest-console'

autocmd BufRead,BufNewFile *.rest setlocal filetype=rest

" This is against W3C recommendations
" let g:vrc_allow_get_request_body = 1

let g:vrc_cookie_jar = '/tmp/vrc_cookie_jar'

let g:vrc_follow_redirects = 1

let g:vrc_include_response_header = 1
let g:vrc_debug = 0

" breaks result formatting...
let g:vrc_show_command = 0

let g:vrc_horizontal_split = 1

let g:vrc_set_default_mapping = 0

" let g:vrc_connect_timeout = 1
let g:vrc_max_time = 1

function! RestCall(...) abort
    " VrcQuery messes up current buffer position
    let b:winview = winsaveview()
    call VrcQuery()
    if(exists('b:winview')) | call winrestview(b:winview) | endif
    only
    execute 'edit ' b:vrc_output_buffer_name
    setlocal filetype=txt
    setlocal modifiable
endfunction
