finish
" Chained completion that works the way you want!
PackAdd lifepillar/vim-mucomplete

set completeopt+=menu,menuone

set shortmess+=c

" For automatic completion, you most likely want one of:
set completeopt+=noinsert " or
" set completeopt+=noinsert,noselect

let g:mucomplete#enable_auto_at_startup = 1

let g:mucomplete#cycle_with_trigger = 1
