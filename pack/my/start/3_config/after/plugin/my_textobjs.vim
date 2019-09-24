PackAdd kana/vim-textobj-user

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
