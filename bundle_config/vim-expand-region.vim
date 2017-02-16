finish
" visually select increasingly larger regions
NeoBundle 'terryma/vim-expand-region'
" TAGS: textobj

" map } <Plug>(expand_region_expand)
" map { <Plug>(expand_region_shrink)

" Default settings. (NOTE: Remove comments in dictionary before sourcing)
let g:expand_region_text_objects = {
      \ 'ai'  :1,
      \ }
