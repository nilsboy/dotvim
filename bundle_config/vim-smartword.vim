finish
" Smart motions on words
NeoBundle 'kana/vim-smartword'
" NOTE: Annoying - maybe use with different keys than the default w etc.

map w  <Plug>(smartword-w)
map b  <Plug>(smartword-b)
map e  <Plug>(smartword-e)
map ge  <Plug>(smartword-ge)

map <Plug>(smartword-basic-w)  <Plug>CamelCaseMotion_w
map <Plug>(smartword-basic-b)  <Plug>CamelCaseMotion_b
map <Plug>(smartword-basic-e)  <Plug>CamelCaseMotion_e
