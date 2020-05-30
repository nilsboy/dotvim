function! Make(...) abort
  let args = join(a:000)
  let _view=winsaveview()
  silent wall
  let cmd = expandcmd(&makeprg)
  let tempfile = tempname()
  call system(cmd . ' &> ' . tempfile)
  let error = 0
  if v:shell_error > 0
    let error = v:shell_error
    call writefile(['### Command:', 
          \ cmd, '### exited with exit code: '
          \ . v:shell_error], tempfile, 'a')
    let &errorformat = '%m'
  endif
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
  execute 'compiler ' . compiler
  Make
endfunction
command! -nargs=* MakeWith call MakeWith(<f-args>)

nnoremap <silent> <leader>x :call MakeWith(b:formatter)<cr>
nnoremap <silent> <leader>X :MakeWith prettier-json<cr>

