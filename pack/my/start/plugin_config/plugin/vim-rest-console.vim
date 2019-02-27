" A REST console for Vim.
PackAdd diepm/vim-rest-console

" This is against W3C recommendations
" let g:vrc_allow_get_request_body = 1

" deprecated
" let g:vrc_cookie_jar = '/tmp/vrc_cookie_jar'

" deprecated
" let g:vrc_follow_redirects = 1

" also automatically formats response when this is set?
" deprecated
" let g:vrc_include_response_header = 1
let g:vrc_debug = 0

" breaks result formatting...
let g:vrc_show_command = 1

let g:vrc_horizontal_split = 1
let g:vrc_set_default_mapping = 0
let g:vrc_syntax_highlight_response = 0

" let g:vrc_connect_timeout = 1
" deprecated
" let g:vrc_max_time = 1

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
  let fileName = '/tmp/rest-call.' . g:MyRestConsoleResultId . '.restresult'
  let b:vrc_output_buffer_name = fileName

  " VrcQuery messes up current buffer position
  let b:winview = winsaveview()
  keepjumps call VrcQuery()
  if(exists('b:winview')) | call winrestview(b:winview) | endif

  only

  execute 'keepjumps edit ' . b:vrc_output_buffer_name

  set buftype=
  set modifiable
  setlocal nowrap
  setlocal filetype=json
  silent! keepjumps g/^curl.*Couldn't connect to server/ :normal "_dd
  silent! keepjumps g/^HTTP/ :normal gcip
  " keepjumps normal gggcip

  let is_json = search('json', 'n')
  if is_json
    " keepjumps normal! gg"adap
    keepjumps Neoformat! json
    " keepjumps normal! gg"aP
  endif

  " NOTE: % is very slow on big bodies:
  " keepjumps normal G%kgcgg
  " keepjumps normal! G%k"adgg

  " setlocal filetype=restresult

  " keepjumps normal! gg"aP
  " keepjumps normal! G%k
  keepjumps normal! gg
endfunction
