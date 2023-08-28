let &l:commentstring = '# %s'
highlight clear snipLeadingSpaces

setl expandtab

let b:outline = '^(snippet|def)'
setlocal suffixesadd=.snippets

setlocal keywordprg=:help
