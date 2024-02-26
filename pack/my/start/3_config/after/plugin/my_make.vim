let g:my_make#lastCommands = {}

function! MakeWith(opts) abort
  let compiler = get(a:opts, 'compiler')
  let args = get(a:opts, 'args', '')
  let loclist = get(a:opts, 'loclist')
  let rerun = get(a:opts, 'rerun')
  let name = get(a:opts, 'name', 'unknown')

  silent wall

  call nb#debug('### MakeWith loading compiler: ' . compiler)
  " Jumps around:
  " let view=winsaveview()
  let pos = getcurpos()
  let currentCwd = getcwd()
  let &makeprg = ''
  " echo g:my_make#lastCommands

  try
    if rerun == 1
      call nb#debug('MakeWith rerunning last command')
      let &makeprg = g:my_make#lastCommands[name . 'Makeprg']
      let &errorformat = g:my_make#lastCommands[name . 'Errorformat']
      let args = g:my_make#lastCommands[name . 'Args']
      let compiler = g:my_make#lastCommands[name . 'Compiler']
    else
      silent execute 'keepjumps compiler ' . compiler
      if &makeprg == ''
        call nb#error('&makeprg not set by compiler: ' . compiler)
        return
      endif
      " let &makeprg = 'timeout 5s ' . &makeprg
      let &makeprg = 'cd ' . currentCwd . ' ; ' . &makeprg
    endif

    " NOTE: make deletes the intermediate &makeef (errorfile)
    " SEE ALSO: MyQuickfixDump for debuggin help
    call nb#debug('MakeWith &errorformat: ' . &errorformat)
    if loclist
      call nb#debug('Running lmake with &makeprg:' . &makeprg)
      silent execute 'lmake! ' . args
    else
      call nb#debug("Running make with &makeprg:", &makeprg)
      silent execute 'make! ' . args
    endif
  catch
    execute 'cd ' . currentCwd
    call nb#error('Failed to run &makeprg: ' . &makeprg)
    call nb#error('v:exception' . v:exception)
    return
  finally  
    silent wall
    " call winrestview(view)
  endtry

  call setqflist([], 'a', { 'title' : compiler })

  if !rerun
    let g:my_make#lastCommands[name . 'Makeprg'] = &makeprg
    let g:my_make#lastCommands[name . 'Errorformat'] = &errorformat
    let g:my_make#lastCommands[name . 'Args'] = args
    let g:my_make#lastCommands[name . 'Compiler'] = compiler
  endif

  " TBD: parse qflist to look for bash errors in the form of ^/bin/bash?
  call nb#debug('MakeWith done.')

  " prettier needs :edit - does not touch timestamp?
  " But resets buffer filetype, cursor pos etc.
  " checktime does not help:
  " silent execute 'checktime ' . expand('%:p')
  silent edit

  keepjumps call setpos('.', pos)

  if loclist
    lwindow
  else
    cwindow
  endif
endfunction

" formatting
nnoremap <silent> <leader>x :silent call MakeWith({'name': 'formatter', 'compiler': b:formatter})<cr>

function! my_make#forceJsonFormat() abort
  call MakeWith({'name': 'formatter', 'compiler': 'prettier-json'})
  silent! keeppatterns keepjumps %s/\\n/\r/g
  silent! keeppatterns keepjumps %s/\v'[[:blank:]\+\n\\]+'//g
  silent! keeppatterns keepjumps %s/<br>/\r/g
  silent! keeppatterns keepjumps %s/&nbsp;/ /g
  silent! keeppatterns keepjumps %s/\/app\/src/src/g
endfunction
nnoremap <silent> <leader>X :call my_make#forceJsonFormat()<cr>

" executing
nnoremap <silent> <leader>ef :call MakeWith({'name': 'myrunprg', 'compiler': b:myrunprg, 'args': expand('%:p')})<cr>
nnoremap <silent> <leader>el :call MakeWith({'name': 'myrunprg', 'compiler': 'bash', 'args': substitute(getline('.'), '\v^["#/ ]+', "", "")})<cr>
nnoremap <silent> <leader>ee :call MakeWith({'name': 'myrunprg', 'rerun': 1})<cr>

" testing
nmap <silent> <leader>tf :silent call my_make#testFile()<cr>
nmap <silent> <leader>tn :silent call my_make#testNearest()<cr>
nmap <silent> <leader>tt :silent call MakeWith({'name': 'test', 'rerun': 1})<cr>

let g:testNearest = 0

function! my_make#testFile() abort
  let g:testNearest = 0
  call MakeWith({'name': 'test', 'compiler': b:tester, 'args': expand('%:p')})
endfunction

function! my_make#testNearest() abort
  let g:testNearest = 1
  call MakeWith({'name': 'test', 'compiler': b:tester, 'args': expand('%:p')})
endfunction

