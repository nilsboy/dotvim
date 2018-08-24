" visually select increasingly larger regions
NeoBundle 'terryma/vim-expand-region'
" TAGS: textobj

map <cr> <Plug>(expand_region_expand)
vmap <bs> <Plug>(expand_region_shrink)

let g:expand_region_text_objects = {
  \ 'i"'  :1,
  \ 'a"'  :1,
  \ 'i''' :1,
  \ 'a''' :1,
  \ 'i`'  :1,
  \ 'a`'  :1,
  \ 'i]'  :1,
  \ 'a]'  :1,
  \ 'ib'  :1,
  \ 'ab'  :1,
  \ 'iB'  :1,
  \ 'aB'  :1,
  \ }
