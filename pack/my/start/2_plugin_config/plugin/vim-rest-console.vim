" TBD: checkout webapi-vim
"
" A REST console for Vim.
" PackAdd diepm/vim-rest-console
PackAdd nilsboy/vim-rest-console

" This is against W3C recommendations
" let g:vrc_allow_get_request_body = 1

" deprecated
" let g:vrc_cookie_jar = '/tmp/vrc_cookie_jar'

let g:vrc_debug = 0

" breaks result formatting...
let g:vrc_show_command = 1
let g:vrc_show_command_in_result_buffer = 1
let g:vrc_show_command_in_quickfix = 0

" let g:vrc_curl_timeout = '5s'
let g:vrc_curl_timeout = '1h'

let g:vrc_horizontal_split = 1
let g:vrc_set_default_mapping = 0
let g:vrc_syntax_highlight_response = 0

" Be quiet and only show errors.
" NOTE: --insecure causes: curl: (7) Couldn't connect to server
let g:vrc_curl_opts = {
      \ '--globoff' : '',
      \ '-i' : '',
      \ '-L' : '',
      \ '-S' : '',
      \ '-s' : '',
      \ '--connect-timeout' : '5',
      \ '--insecure': '',
      \ '--trace-time': '',
      \ '--max-time' : '9999',
      \}

" Sort JSON keys
let g:vrc_auto_format_response_enabled = 0

function! MyRestConsoleCall(...) abort

  let b:winview = winsaveview()
  " NOTE: creates a buffer with buftype=nofile
  let b:vrc_output_buffer_name = nb#createTempFile('rest-client-temp', '', 'txt')
  call VrcQuery()
  " wincmd p

  execute 'keepjumps noautocmd edit ' . b:vrc_output_buffer_name
  only

  " keepjumps normal! gg"zyG
  " let res = getreg('z')
  
  let res = join(getline(1, '$'), "\n")
  let restFile = expand('%:p')
  bwipe!

  if(exists('b:winview')) | call winrestview(b:winview) | endif

  let pathEnd = g:_vrc_request_path
  call nb#createTempBuffer('rest', pathEnd, 'restresult')

  " call setline('.', 'haha')
  " keepjumps normal! "zP
  " call setline('.', res)
  " let output = join(a:outputInfo['outputChunks'], "\n\n")
  call setline('.', split(substitute(res, '[[:return:]]', '', 'g'), '\v\n'))

  let is_json = search('^content-type: application/json', 'n')
  let is_error = search('"stack":', 'n')

  setlocal buftype=
  setlocal modifiable

  silent! keeppatterns keepjumps g/^curl.*Couldn't connect to server/d _
  silent! keeppatterns keepjumps g/Connection timed out after .* milliseconds/d _

  " silent! keeppatterns keepjumps g/\v^(HTTP|REQUEST)/ :normal gcip
  " silent! keeppatterns keepjumps g/\v^HTTP/g/^REQUEST/ :normal jgc

  let @z = ''
  silent! keeppatterns keepjumps normal! "z2dap

  setlocal filetype=text

  if is_json
    setlocal filetype=jsonc
    keepjumps call MakeWith({'compiler': b:formatter})
  endif

  silent! keeppatterns keepjumps normal! gg"zP
  silent! keeppatterns keepjumps normal 2gcap

  silent! keeppatterns keepjumps %s/\\n/\r/g
  silent! keeppatterns keepjumps %s/<br>/\r/g
  silent! keeppatterns keepjumps %s/&nbsp;/ /g

  " "stack": "NoApiAtThisLocationError: Encountered a NoApiAtThisLocationError
  " silent! keeppatterns keepjumps %s/stack\"\: "/\r/g

  keepjumps normal! gg
  " call append(0, [filename])

  setlocal wrap

  if is_error
    setlocal filetype=text
    setlocal nowrap
    setlocal syntax=off
  endif

  write
  call matchadd('todo', '\v^// (HTTP.* \d+.*$|age: \d+\s*$|.*cache.*|.*service-version.*)')
  call matchadd('todo', '\v(HTTP.* \d+.*$|age: \d+\s*$|.*cache.*|.*service-version.*)')
  " setlocal nowrap
endfunction

if exists("b:my_vim_rest_console_ftPluginLoaded")
  finish
endif
let b:my_vim_rest_console_ftPluginLoaded = 1

augroup vim-rest-console#augroupRestresult
  autocmd!
  autocmd BufRead,BufNewFile *.restresult setlocal filetype=restresult
augroup END
