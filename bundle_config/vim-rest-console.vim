" A REST console for Vim.
NeoBundle 'diepm/vim-rest-console'

autocmd BufRead,BufNewFile *.rest setlocal filetype=rest

" This is against W3C recommendations
let g:vrc_allow_get_request_body = 1

let g:vrc_cookie_jar = '/tmp/vrc_cookie_jar'

" let g:vrc_follow_redirects = 1

let g:vrc_debug = 0

let g:vrc_horizontal_split = 1

let g:vrc_set_default_mapping = 0

" let g:vrc_trigger = <C-j>

" let g:vrc_connect_timeout = 1
let g:vrc_max_time = 1
