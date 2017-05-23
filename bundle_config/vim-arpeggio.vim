finish " #######################################################################
" Mappings for simultaneously pressed keys
NeoBundle 'kana/vim-arpeggio'

" Note: Does only make sense for insert mode? Because keys must not be
" included in existing mappings:
" https://github.com/kana/vim-arpeggio/issues/3#issuecomment-44111543

" Note: groups of mapped keys must be unique inside a mode.

if neobundle#tap('vim-arpeggio') 
  function! neobundle#hooks.on_post_source(bundle) abort

    Arpeggio inoremap jk <esc>
    Arpeggio inoremap ;k <esc><c-b>i
    " Arpeggio inoremap ;j <esc><c-f>i
    " Note: calling functions does not work?
    " Arpeggio inoremap ;j :call MyVimArpeggio_jump()<cr>
    Arpeggio inoremap ;e <esc>:copen<cr>

  endfunction
  call neobundle#untap()
endif

function! MyVimArpeggio_jump()
  normal <esc><c-f>
  startinsert
endfunction
