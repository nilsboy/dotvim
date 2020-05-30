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

let g:vrc_horizontal_split = 1
let g:vrc_set_default_mapping = 0
let g:vrc_syntax_highlight_response = 0

" be quiet and only show errors
" note --insecure causes: curl: (7) Couldn't connect to server
let g:vrc_curl_opts = {
      \ '-i' : '',
      \ '-L' : '',
      \ '-S' : '',
      \ '-s' : '',
      \ '--connect-timeout' : '1',
      \ '--insecure' : '1',
      \ '--trace-time': '',
      \}
      " \ '--max-time' : '3',

      " always generates 'curl: (7) Couldn't connect to server'
      " as first line in the output:
      " \ '--insecure' : '1',

" Sorts the JSON keys
let g:vrc_auto_format_response_enabled = 0

let g:MyRestConsoleResultId = 0
function! MyRestConsoleCall(...) abort

  let g:MyRestConsoleResultId = g:MyRestConsoleResultId + 1
  let filename = tempname() . '/rest-call.' . g:MyRestConsoleResultId . '.restresult'

  let b:winview = winsaveview()
  keepjumps call VrcQuery()
  if(exists('b:winview')) | call winrestview(b:winview) | endif

  execute 'keepjumps edit __REST_response__'
  only
  keepjumps normal! gg"zyG
  bwipe!
  execute 'keepjumps edit ' filename

  %delete _
  keepjumps normal! "zP

  setlocal buftype=
  setlocal modifiable
  silent! keeppatterns keepjumps g/^curl.*Couldn't connect to server/ :normal! "_dd
  silent! keeppatterns keepjumps g/Connection timed out after .* milliseconds/ :normal! "_dd
  silent! keeppatterns keepjumps g/\v^(HTTP|REQUEST)/ :normal gcip

  call matchadd('todo', '\v^// (HTTP.* \d+.*$|age: \d+\s*$|.*cache.*)')

  let is_json = search('json', 'n')
  if is_json
    let b:formatter = 'prettier-json'
    setlocal filetype=json
    keepjumps call MakeWith(b:formatter)
  endif

  keepjumps normal! gg
  " call append(0, [filename])
  write
  setlocal nowrap
endfunction

if exists("b:my_vim_rest_console_ftPluginLoaded")
  finish
endif
let b:my_vim_rest_console_ftPluginLoaded = 1

autocmd BufRead,BufNewFile *.restresult setlocal filetype=restresult
