finish
" zero config jump to definition
" NOTE: greps for a definition using predefined defintion patterns. Does not
" use &define
NeoBundle 'bounceme/dim-jump'

nnoremap <silent> <leader>gd :DimJumpPos<cr>
