" Moved to MakeWith
finish

let g:testNearest = 0
let g:my_test#cwd = getcwd()

nmap <silent> <leader>tf :call my_test#testFile()<cr>
nmap <silent> <leader>tn :call my_test#testNearest()<cr>
nmap <silent> <leader>tt :call my_test#test(1)<cr>

nmap <silent> <leader>tl :e .make.log<cr>

function! my_test#testFile() abort
  let g:testNearest = 0
  call my_test#test(0)
endfunction

function! my_test#testNearest() abort
  let g:testNearest = 1
  call my_test#test(0)
endfunction

function! my_test#test(rerun)
  if a:rerun == 0
    let g:my_test#cwd = getcwd()
    execute 'compiler! ' . b:tester
    " let &makeprg = 'timeout 5s ' . &makeprg
    let g:my_test#makeprg = &makeprg
    let g:my_test#errorformat = &errorformat
  else
    let &makeprg = g:my_test#makeprg
    let &errorformat = g:my_test#errorformat
  endif
  let currentCwd = getcwd()
  execute 'cd ' . g:my_test#cwd
  call nb#debug('Running test with &makeprg: ' . &makeprg)
  silent make
  let title = &makeprg
  let title = substitute(title, '\vtimeout \d*s\s+', '', 'g') 
  call setqflist([], 'a', { 'title' : title })
  execute 'cd ' . currentCwd
  cwindow
endfunction

