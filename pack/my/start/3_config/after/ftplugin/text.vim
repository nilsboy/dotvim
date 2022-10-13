" See also: https://alols.github.io/2012/11/07/writing-prose-with-vim/
" see also: https://github.com/reedes/vim-pencil

" setlocal formatoptions+=t

" :help format-comments
" let &l:comments = 'nb:>,fb:-'

" Use comment string for quoting
let &l:commentstring = '# %s'

" let &l:define = '\v^(TABLE OF CONTENTS|page \d+|[\u\s]+|[\d\.]+\s+.+)$'
" let &l:define = '\v^(TABLE OF CONTENTS|page \d+|[\u\s]+|[\d\.]+.*)$'

let b:outline = '('
let b:outline .= '^(table of contents|page \d+|[[:upper:]]{1}[[:upper:]\s]+$)'
let b:outline .= '|^---*'
let b:outline .= ')'
" let b:outline = '^(table of contents(?!.*\.\.\..*)|\d+\.[\d\.]*\s+\w+(?!.*\.\.\..*)|---)'

" let b:define = '^([[:upper:]]+[[:upper:][:space:]]+|(?i)page \d+)$'
" let b:define = '^((?-i)[[:upper:]]+[[:upper:][:space:]]+)$'
let &l:define = '\v\c^page\s+'
