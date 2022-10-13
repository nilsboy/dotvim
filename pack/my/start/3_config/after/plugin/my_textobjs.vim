PackAdd kana/vim-textobj-user

" TBD: checkout textobj-between

call textobj#user#plugin('my', {
\   'md-fenced-code-block': {
\     'pattern': [ '\v```.+$\n', '```' ],
\     'select-a': 'aC',
\     'select-i': 'iC',
\   },
\ })
