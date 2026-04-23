PackAdd kana/vim-textobj-user

" TBD: checkout textobj-between
" TBD: checkout textobj#user#move({pattern},

" call textobj#user#plugin('my', {
" \   'md-fenced-code-block': {
" \     'pattern': [ '\v```.+$\n', '```' ],
" \     'select-a': 'aC',
" \     'select-i': 'iC',
" \   },
" \   'jo': {
" \     'pattern': ['\v[a-z0-9\.\-_$]+', '\v[a-z0-9\.\-_$]+'],
" \     'select-a': 'ax',
" \     'select-i': 'ix',
" \   },
" \ })

" aa xxxxxxxxxxxxxxxxxxxxxx aa
" ## xxxxxxxxxxxxxxxxxxxxxx
" ## haha

call textobj#user#plugin('twonumbersigns', {
  \   'twonumbersigns-a': {
  \     'pattern': '\#\#\_.\{-}\#\#.*$',
  \     'select': 'a<enter>',
  \   },
  \   'twonumbersigns-i': {
  \     'pattern': '\#\#\zs\_.\{-}\ze\#\#',
  \     'select': 'i<enter>',
  \   },
  \ })

call textobj#user#plugin('mdinline', {
  \   'twonumbersigns-a': {
  \     'pattern': '````\_.\{-}```.*$',
  \     'select': 'a`',
  \   },
  \   'twonumbersigns-i': {
  \     'pattern': '```\zs\_.\{-}\ze```',
  \     'select': 'i`',
  \   },
  \ })

