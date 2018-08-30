" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! Redir(cmd)
	for win in range(1, winnr('$'))
		if getwinvar(win, 'scratch')
			" execute win . 'windo close'
		endif
	endfor
	if a:cmd =~ '^!'
		execute "let output = system('" . substitute(a:cmd, '^!', '', '') . "')"
	else
		redir => output
		silent execute a:cmd
		redir END
	endif
	new
  only
	" let w:scratch = 1
	" setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
	setlocal buftype=nofile noswapfile
	call setline(1, split(output, "\n"))
endfunction

command! -nargs=1 -complete=command Redir silent call Redir(<f-args>)

" Usage:
" 	:Redir hi ............. show the full output of command ':hi' in a scratch window
" 	:Redir !ls -al ........ show the full output of command ':!ls -al' in a scratch window
