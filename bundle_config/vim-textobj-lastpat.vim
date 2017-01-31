" Text objects for the last searched pattern
NeoBundle 'kana/vim-textobj-lastpat'

if neobundle#tap('vim-textobj-user') 
  function! neobundle#hooks.on_post_source(bundle) abort
    call textobj#user#map('lastpat', {
    \   'n': {
    \     'select': ['a<space>/', 'i<space>/'],
    \   },
    \   'N': {
    \     'select': ['a<space>?', 'i<space>?'],
    \   }
    \ })
  endfunction
  call neobundle#untap()
endif

