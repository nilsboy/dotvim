finish
" Text objects for indented blocks of lines
PackAdd kana/vim-textobj-indent

call textobj#user#map('indent', {
\   '': {
\     'select-a': 'ai',
\     'select-i': 'ii',
\   },
\   'same': {
\     'select-a': 'aI',
\     'select-i': 'iI',
\   }
\ })

