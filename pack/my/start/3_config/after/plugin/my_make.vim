function! Make(...) abort
  let args = join(a:000)
  let _view=winsaveview()
  silent wall
  let cmd = expandcmd(&makeprg)
  let tempfile = tempname()
  call system(cmd . ' &> ' . tempfile)
  let error = 0
  " if v:shell_error > 0
    let error = v:shell_error
    call writefile(['### Command:', 
          \ cmd, '### exited with exit code: '
          \ . v:shell_error], tempfile, 'a')
    " let &errorformat = '%m'
  " endif
  silent wall
  silent edit
  execute 'cgetfile ' . tempfile
  call setqflist([], 'a', { 'title' : cmd })
  if error > 0
    copen
  endif
  call winrestview(_view)
endfunction
command! -nargs=* Make call Make(<f-args>)

function! MakeWith(...) abort
  let compiler = a:1
  let loclist = a:2
  let view=winsaveview()
  silent! execute 'keepjumps compiler ' . compiler
  if loclist
    silent! lmake!
  else
    silent make!
  endif
  call winrestview(view)
  " prettier need edit - does not touch timestamp?
  " But resets buffer filetype etc.
  edit
endfunction
command! -nargs=* MakeWith call MakeWith(<f-args>, 0)
command! -nargs=* LMakeWith call MakeWith(<f-args>, 1)

nnoremap <silent> <leader>x :call MakeWith(b:formatter, 1)<cr>
nnoremap <silent> <leader>X :call MakeWith('prettier-json', 1)<cr>

function! my_make#showConfig() abort
  Redir echo "&makeprg: " | echo &makeprg | echo "" | echo "&errorformat:" | echo &errorformat
  silent! keepjumps %s/\\|/\r    \\|/g
endfunction
nnoremap <silent> <leader>vM :call my_make#showConfig()<cr>
