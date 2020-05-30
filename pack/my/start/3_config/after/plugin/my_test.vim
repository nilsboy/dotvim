let g:testNearest = 0
let g:my_test#cwd = getcwd()

nmap <silent> <leader>tf :call my_test#testFile()<cr>
nmap <silent> <leader>tn :call my_test#testNearest()<cr>
nmap <silent> <leader>tt :call my_test#testRerun()<cr>

function! my_test#testFile() abort
  let g:testNearest = 0
  call my_test#test()
endfunction

function! my_test#testNearest() abort
  let g:testNearest = 1
  call my_test#test()
endfunction

function! my_test#testRerun() abort
  echo g:my_test#cwd
  let currentCwd = getcwd()
  execute 'cd ' . g:my_test#cwd
  if g:testNearest == 1
    call my_test#testNearest()
  else
    call my_test#testFile()
  endif
  execute 'cd ' . currentCwd
endfunction

function! my_test#test()
  let g:my_test#cwd = getcwd()
  execute 'compiler! ' . b:tester
  execute 'silent make!'
endfunction

