finish
" Smart selection of the closest text object 
PackAdd gcmt/wildfire.vim

" This selects the next closest text object.
map r\> <Plug>(wildfire-fuel)

" This selects the previous closest text object.
vmap r\< <Plug>(wildfire-water)

nmap <leader>s <Plug>(wildfire-quick-select)
