" TODO: use different key
finish
PackAdd kana/vim-textobj-user

call textobj#user#plugin('file', {
\   'file': {
\     'pattern': '\v[[:upper:][:lower:]\/\.]+(\:\d+)*(:\d+)*',
\     'select': ['af', 'if'],
\   },
\ })
