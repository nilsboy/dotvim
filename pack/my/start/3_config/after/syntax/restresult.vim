setlocal syntax=json

" TBD:
" call matchadd('todo', '\v(HTTP.* \d+.*$|age: \d+\s*$|.*cache.*|.*service-version.*)')
syntax keyword myCache http cache age service-version containedin=ALL

highlight link myCache Todo

