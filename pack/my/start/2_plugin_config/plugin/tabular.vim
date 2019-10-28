" Sometimes, it's useful to line up text.
" TAGS: align
PackAdd godlygeek/tabular

" To align by spaces use :Tabularize multiple_spaces

AddTabularPipeline multiple_spaces / \{2,}/
  \ map(a:lines, "substitute(v:val, ' \{2,}', '  ', 'g')")
  \   | tabular#TabularizeStrings(a:lines, '  ', 'l0')

" needs no mappings
" nmap <Leader>a& :Tabularize /&<CR>
" vmap <Leader>a& :Tabularize /&<CR>
" nmap <Leader>a= :Tabularize /=<CR>
" vmap <Leader>a= :Tabularize /=<CR>
" nmap <Leader>a: :Tabularize /:<CR>
" vmap <Leader>a: :Tabularize /:<CR>
" nmap <Leader>a:: :Tabularize /:\zs<CR>
" vmap <Leader>a:: :Tabularize /:\zs<CR>
" nmap <Leader>a, :Tabularize /,<CR>
" vmap <Leader>a, :Tabularize /,<CR>
" nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
" vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
