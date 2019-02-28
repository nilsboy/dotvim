" Based on:
" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! Redir(cmd, append)
	if a:cmd =~ '^!'
		execute "let output = system('" . substitute(a:cmd, '^!', '', '') . "')"
	else
		redir => output
		silent execute a:cmd
		redir END
	endif
  if ! a:append
    	new
      only
  endif
	call append('.', split(output, "\n"))
endfunction

command! -nargs=1 -complete=command Redir silent call Redir(<f-args>, 0)
command! -nargs=1 -complete=command RedirAppend silent call Redir(<f-args>, 1)