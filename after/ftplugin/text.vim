" TODO:
" setlocal formatoptions+=jan
" setlocal formatoptions-=c
" :h fo-table

setlocal textwidth=80

" Leading dash starts a list item
setlocal formatlistpat+="|^\s*-\s+"

finish

" Note: use par for email formatting / cleanup?
"  - let &l:formatprg = 'par -w10'
