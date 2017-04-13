" Restore defaults UltiSnips overides these
let &tabstop = 2
let &softtabstop = &tabstop
let &shiftwidth = &tabstop
set shiftround
set smarttab
set expandtab

augroup s:SyntaxFix
  autocmd!
  autocmd Syntax snippets highlight snipLeadingSpaces NONE
augroup END

