function! nb#buffer#isNamed(bufnr) abort
  if empty(bufname(a:bufnr))
    return 0
  endif
  return 1
endfunction

function! nb#buffer#isEmpty(bufnr) abort
  if getbufline(a:bufnr, 1, "$") == ['']
    return 1
  else
    return 0
  endif
endfunction

