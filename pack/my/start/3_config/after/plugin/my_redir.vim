" Redirect the output of a Vim or external command into a scratch buffer
" Based on:
" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! Redir(cmd, append, verbose)
	if a:cmd =~ '^!'
		execute "let output = system('" . substitute(a:cmd, '^!', '', '') . "')"
	else
		redir => output
		silent execute a:cmd
		redir END
	endif
  if a:append
    keepjumps normal! Go
  else
    let tempfile = tempname() . '_' . fnameescape(a:cmd)
    keepjumps execute 'edit ' . tempfile
    only
    " setlocal buftype=nowrite
    write
  endif
  if a:verbose
    call append(line('$'), "### " . a:cmd)
  endif
	call append(line('$'), split(output, "\n"))
  if !a:append
    normal! ggdd
  endif
endfunction

command! -nargs=1 -complete=command Redir silent call Redir(<f-args>, 0, 0)
command! -nargs=1 -complete=command RedirAppend silent call Redir(<f-args>, 1, 0)
command! -nargs=1 -complete=command Redirv silent call Redir(<f-args>, 0, 1)
command! -nargs=1 -complete=command RedirAppendv silent call Redir(<f-args>, 1, 1)
