" Enhancing in-buffer search experience
" NeoBundle 'junegunn/vim-slash'

" Use own fork for slash_immobile option
NeoBundle 'nilsboy/vim-slash'

let g:slash_immobile = 0

if neobundle#tap('vim-slash') 
  function! neobundle#hooks.on_post_source(bundle) abort
    " the default mapping prints <cr><Plug>(slash-trailer) in command mode
    cunmap <cr>
  endfunction
  call neobundle#untap()
endif
