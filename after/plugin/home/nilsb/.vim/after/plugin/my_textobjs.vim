call textobj#user#plugin('file', {
\   'file': {
\     'pattern': '\v[[:upper:][:lower:]\/\.]+(\:\d+)*(:\d+)*',
\     'select': ['af', 'if'],
\   },
\ })
