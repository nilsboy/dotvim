" See also: https://alols.github.io/2012/11/07/writing-prose-with-vim/

setlocal syntax=txt

setlocal formatoptions+=t

" :help format-comments
let &l:comments = 'nb:>,fb:-'

" Use comment string for quoting
let &l:commentstring = '> %s'
