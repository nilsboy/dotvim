finish
" Text objects for the last searched pattern
" Superseded by now build in gn / gN.
PackAdd kana/vim-textobj-lastpat

call textobj#user#map('lastpat', {
\   'n': {
\     'select': ['a<space>/', 'i<space>/'],
\   },
\   'N': {
\     'select': ['a<space>?', 'i<space>?'],
\   }
\ })
