finish " #######################################################################

" Mappings for simultaneously pressed keys
NeoBundle 'kana/vim-arpeggio'

if neobundle#tap('vim-arpeggio') 
  function! neobundle#hooks.on_post_source(bundle) abort
    Arpeggiomap ;k <c-b>
    Arpeggiomap ;j <c-f>
    Arpeggioimap ;k <esc><c-b>i
    Arpeggioimap ;j <esc><c-f>i
    Arpeggiomap jk <esc>
    Arpeggioimap jk <esc>
    " Arpeggiomap jkl; :copen \| :wincmd w<cr>
    Arpeggiomap jkl; :copen
  endfunction
  call neobundle#untap()
endif
