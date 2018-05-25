" visually select increasingly larger regions
NeoBundle 'terryma/vim-expand-region'
" TAGS: textobj

map <cr> <Plug>(expand_region_expand)
vmap <bs> <Plug>(expand_region_shrink)

" Default settings. (NOTE: Remove comments in dictionary before sourcing)
let g:expand_region_text_objects = {
  \ 'iw'  :0,
  \ 'iW'  :0,
  \ 'i"'  :0,
  \ 'i''' :0,
  \ 'i`'  :0,
  \ 'i]'  :1,
  \ 'a]'  :1,
  \ 'ib'  :1,
  \ 'ab'  :1,
  \ 'iB'  :1,
  \ 'aB'  :1,
  \ 'il'  :0,
  \ 'ip'  :0,
  \ 'ie'  :0,
  \ }
