finish
" Mappings for simultaneously pressed keys
PackAdd kana/vim-arpeggio

" Note: Does only make sense for insert mode? Because keys must not be
" included in existing mappings:
" https://github.com/kana/vim-arpeggio/issues/3#issuecomment-44111543

" Note: groups of mapped keys must be unique inside a mode.

Arpeggio inoremap jk <esc>
Arpeggio inoremap ;k <esc><c-b>i
Arpeggio inoremap ;e <esc>:copen<cr>
