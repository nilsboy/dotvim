" TODO:
" setlocal formatoptions+=jan
" setlocal formatoptions-=c

setlocal textwidth=80

" Leading dash start a list item
setlocal formatlistpat+="|^\s*-\s+"

finish

" Note: use par for email formatting / cleanup?
"  - let &l:formatprg = 'par -w10'
