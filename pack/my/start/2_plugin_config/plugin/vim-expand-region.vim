" visually select increasingly larger regions
PackAdd terryma/vim-expand-region
" TAGS: textobj

nmap <cr> <Plug>(expand_region_expand)
vmap <bs> <Plug>(expand_region_shrink)

let g:expand_region_text_objects = {
  \ 'iw'  :1,
  \ 'iW'  :1,
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
