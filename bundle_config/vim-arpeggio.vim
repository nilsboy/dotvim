finish
" Mappings for simultaneously pressed keys
NeoBundle 'kana/vim-arpeggio'


if neobundle#tap('unite.vim') 
    function! neobundle#hooks.on_post_source(bundle)

    Arpeggiomap jk <C-b>

    endfunction
    call neobundle#untap()
endif
