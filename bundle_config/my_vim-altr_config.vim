finish
" Switch to the missing file without interaction
NeoBundle 'kana/vim-altr', { 'name': 'vim-altr' }

" NOTE: can't get it to work

if neobundle#tap('vim-altr') 
  function! neobundle#hooks.on_post_source(bundle) abort

    call altr#remove_all()
    call altr#define('%/test/%/%-test.txt', '%/src/%/%.js')

    nmap <leader>gn <Plug>(altr-forward)
    " nmap <S-F2>  <Plug>(altr-back)
    
  endfunction
  call neobundle#untap()
endif
