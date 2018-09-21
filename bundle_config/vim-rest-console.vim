" A REST console for Vim.
NeoBundle 'diepm/vim-rest-console'

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

" let g:vrc_connect_timeout = 1
" deprecated
" let g:vrc_max_time = 1

" be quiet and only show errors
let g:vrc_curl_opts = {
      \ '-s' : '',
      \ '-S' : '',
      \ '-i' : '',
      \ '-L' : '',
      \ '--connect-timeout' : '1',
      \}

" Sorts the JSON keys
let g:vrc_auto_format_response_enabled = 0

let g:MyRestConsoleResultId = 0
function! MyRestConsoleCall(...) abort

  " VrcQuery messes up current buffer position
  let b:winview = winsaveview()
  call VrcQuery()
  if(exists('b:winview')) | call winrestview(b:winview) | endif

  only

  let g:MyRestConsoleResultId = g:MyRestConsoleResultId + 1
  let fileName = '/tmp/rest-call.' . g:MyRestConsoleResultId . '.restresult'

  silent execute 'edit ' . b:vrc_output_buffer_name
  set buftype=
  silent! execute 'saveas! ' . fileName

  setlocal filetype=restresult

  let is_json = search('json', 'n')

  set modifiable
  normal G%kgcgg
  normal! G%k"adgg

  if is_json
    Neoformat
  endif

  normal! gg"aP
  normal! G%k
endfunction
