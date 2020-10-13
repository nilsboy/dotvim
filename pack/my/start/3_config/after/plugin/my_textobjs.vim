PackAdd kana/vim-textobj-user

" checkout textobj-between

call textobj#user#plugin('my', {
\   'rest-a': {
\     'pattern': '\v\s.{-}\ze[`"'')\]\}]+',
\     'select': 'ar',
\   },
\   'rest-i': {
\     'pattern': '\v\s\zs.{-}\ze[`"'')\]\}]+',
\     'select': 'ir',
\   },
\ })
