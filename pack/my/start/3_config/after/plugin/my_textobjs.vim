finish
PackAdd kana/vim-textobj-user

" TBD: checkout textobj-between

call textobj#user#plugin('my', {
\   'md-fenced-code-block': {
\     'pattern': [ '\v```.+$\n', '```' ],
\     'select-a': 'aC',
\     'select-i': 'iC',
\   },
\   'jo': {
\     'pattern': ['\v[a-z0-9\.\-_$]+', '\v[a-z0-9\.\-_$]+'],
\     'select-a': 'ax',
\     'select-i': 'ix',
\   },
\ })


	" call textobj#user#plugin('braces', {
	" \   'angle': {
	" \     'pattern': ['<<', '>>'],
	" \     'select-a': 'aA',
	" \     'select-i': 'iA',
	" \   },
	" \ })
