" A REST console for Vim.
NeoBundle 'diepm/vim-rest-console'

autocmd BufRead,BufNewFile *.{rest} setlocal filetype=rest

" This is against W3C recommendations
let b:vrc_allow_get_request_body = 1

let b:vrc_cookie_jar = '/tmp/vrc_cookie_jar'

" let b:vrc_follow_redirects = 1

let b:vrc_debug = 1

let b:vrc_horizontal_split = 1

let b:vrc_set_default_mapping = 0
nmap <silent> <CR> :call VrcQuery()<cr>:only<cr>:e __REST_response__<cr>
" let g:vrc_trigger = <C-j>
