finish
" Switch to the missing file without interaction
PackAdd kana/vim-altr

" NOTE: can't get it to work

call altr#remove_all()
call altr#define('%/test/%/%-test.txt', '%/src/%/%.js')

nmap <leader>gn <Plug>(altr-forward)
" nmap <S-F2>  <Plug>(altr-back)
