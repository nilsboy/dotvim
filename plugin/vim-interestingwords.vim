finish
" TODO: clobbers <leader>k
" highlight and navigate through (multiple) different words in a buffer 
PackAdd lfv89/vim-interestingwords 
" TAGS: search highlight colors

nnoremap <silent> <leader>gH :call InterestingWords('n')<cr>
" nnoremap <silent> //K :call UncolorAllWords()<cr>

" nnoremap <silent> n :call WordNavigation('forward')<cr>
" nnoremap <silent> N :call WordNavigation('backward')<cr>
