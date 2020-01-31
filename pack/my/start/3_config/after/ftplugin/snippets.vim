let &l:commentstring = '# %s'
highlight clear snipLeadingSpaces

let b:outline = '^(snippet\ |def\ )'

" This also prevents the ftplugin from UltiSnips from running and messing with expandtab
if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin = 1
